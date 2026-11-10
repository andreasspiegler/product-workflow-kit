#!/bin/bash
# Outbound traffic only to an allowlist. Runs on every container start (postStartCommand).
# Derived from Anthropic's reference devcontainer (anthropics/claude-code/.devcontainer), tightened:
# no outbound SSH, no access to the host or LAN, DNS only to the configured resolver, IPv6 blocked.
set -euo pipefail
IFS=$'\n\t'

# Required: the container start fails if one of these cannot be resolved.
REQUIRED_DOMAINS=(
  api.anthropic.com      # Claude Code
  platform.claude.com    # Claude Code login (OAuth)
  console.anthropic.com  # Claude Code login (OAuth, older endpoints)
  claude.ai              # Claude Code login
{{STACK_DOMAINS}})
# Optional: documentation or other sources agents may read. Add domains here, then rebuild.
OPTIONAL_DOMAINS=(
)

DOCKER_DNS_RULES=$(iptables-save -t nat | grep "127\.0\.0\.11" || true)
NAMESERVERS=$(awk '/^nameserver/ {print $2}' /etc/resolv.conf | grep -E '^[0-9.]+$' || true)

iptables -F; iptables -X
iptables -t nat -F; iptables -t nat -X
iptables -t mangle -F; iptables -t mangle -X
ipset destroy allowed-domains 2>/dev/null || true

if [ -n "$DOCKER_DNS_RULES" ]; then
  iptables -t nat -N DOCKER_OUTPUT 2>/dev/null || true
  iptables -t nat -N DOCKER_POSTROUTING 2>/dev/null || true
  echo "$DOCKER_DNS_RULES" | xargs -L 1 iptables -t nat
fi

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

for ns in $NAMESERVERS; do
  iptables -A OUTPUT -p udp -d "$ns" --dport 53 -j ACCEPT
  iptables -A OUTPUT -p tcp -d "$ns" --dport 53 -j ACCEPT
done

ipset create allowed-domains hash:net

add_domain() {
  local domain=$1 ips ip
  ips=$(dig +short A "$domain" | grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' || true)
  [ -n "$ips" ] || return 1
  while read -r ip; do
    ipset add -exist allowed-domains "$ip"
  done <<< "$ips"
}

for d in "${REQUIRED_DOMAINS[@]}"; do
  add_domain "$d" || { echo "ERROR: cannot resolve $d" >&2; exit 1; }
done
for d in "${OPTIONAL_DOMAINS[@]}"; do
  add_domain "$d" || echo "Note: cannot resolve $d, skipped"
done

# Relay port for a forwarded app (see expose.sh), reachable only via the host loopback mapping
iptables -A INPUT -p tcp --dport 9999 -j ACCEPT

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -m set --match-set allowed-domains dst -j ACCEPT
iptables -A OUTPUT -j REJECT --reject-with icmp-admin-prohibited

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

if command -v ip6tables >/dev/null && ip6tables -L >/dev/null 2>&1; then
  ip6tables -F
  ip6tables -A INPUT -i lo -j ACCEPT
  ip6tables -A OUTPUT -o lo -j ACCEPT
  ip6tables -P INPUT DROP
  ip6tables -P FORWARD DROP
  ip6tables -P OUTPUT DROP
fi

# Self-test
fail=0
if curl -s --connect-timeout 5 https://example.com >/dev/null; then
  echo "ERROR: example.com reachable, firewall not effective" >&2; fail=1
fi
if ! curl -s --connect-timeout 5 -o /dev/null https://api.anthropic.com; then
  echo "ERROR: api.anthropic.com not reachable" >&2; fail=1
fi
gw=$(ip route | awk '/default/ {print $3; exit}')
if [ -n "$gw" ] && timeout 3 bash -c "</dev/tcp/$gw/22" 2>/dev/null; then
  echo "ERROR: host ($gw) reachable" >&2; fail=1
fi
[ "$fail" -eq 0 ] || exit 1
echo "Firewall active: HTTPS allowlist only, no host, no LAN, no IPv6."
