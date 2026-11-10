# Agent sandbox: agents work here and see only this repository,
# not the host's home directory, SSH keys, tokens, or Docker socket.
FROM {{BASE_IMAGE}}

ARG TZ=UTC
ENV TZ=$TZ

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git less procps nano jq socat sudo \
    iptables ipset iproute2 dnsutils \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
{{STACK_TOOLS}}
# Non-root user with UID 1000 so files in the bind-mounted repository keep the
# host owner. Reuses an existing UID-1000 user from the base image if present.
RUN if existing="$(getent passwd 1000 | cut -d: -f1)" && [ -n "$existing" ]; then \
      usermod --login dev --home /home/dev --move-home "$existing" \
      && groupmod --new-name dev "$(getent group 1000 | cut -d: -f1)"; \
    else \
      useradd --create-home --uid 1000 --shell /bin/bash dev; \
    fi \
  && mkdir -p /workspace{{STACK_DIRS}} /home/dev/.claude /home/dev/.cache \
  && chown -R dev:dev /workspace /home/dev

# The firewall script is the only thing dev may run with sudo.
COPY init-firewall.sh /usr/local/bin/init-firewall.sh
RUN chmod 0755 /usr/local/bin/init-firewall.sh \
  && echo "dev ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/dev-firewall \
  && chmod 0440 /etc/sudoers.d/dev-firewall

USER dev
WORKDIR /workspace
ENV PATH=/home/dev/.local/bin:$PATH

# Claude Code pinned; update by changing the version and rebuilding.
ARG CLAUDE_CODE_VERSION={{CLAUDE_CODE_VERSION}}
RUN curl -fsSL https://claude.ai/install.sh | bash -s "$CLAUDE_CODE_VERSION"

RUN echo 'PS1="({{PRODUCT_NAME}}-sandbox) \w \$ "' >> /home/dev/.bashrc
