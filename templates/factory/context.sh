#!/usr/bin/env bash
# Writes the trusted issue context for the factory's agents to <out-dir>/issue.md:
# the issue itself, comments from people with write access, and the factory's own
# comments. Everything else is left out, so outside text cannot steer the agents.
# Protected path: the factory must not change this file. Edit it by hand.
#
#   .factory/context.sh <issue-number> <out-dir>     (needs GH_TOKEN and GITHUB_REPOSITORY)
set -euo pipefail

issue="$1"
out="$2"
mkdir -p "$out"

trusted='(.author_association | IN("OWNER", "MEMBER", "COLLABORATOR")) or (.user.login == "github-actions[bot]" and (.body | contains("<!-- factory:")))'

issue_json="$(gh api "repos/$GITHUB_REPOSITORY/issues/$issue")"
comments_json="$(gh api --paginate "repos/$GITHUB_REPOSITORY/issues/$issue/comments" | jq -s 'add // []')"

{
  jq -r '"# #\(.number): \(.title)\n\nOpened by @\(.user.login) (\(.author_association)).\n\n\(.body // "")\n"' <<<"$issue_json"
  echo "## Comments from people with write access and from the factory"
  echo
  jq -r ".[] | select($trusted) | \"### @\\(.user.login), \\(.created_at)\n\n\\(.body)\n\"" <<<"$comments_json"
  omitted="$(jq "[.[] | select(($trusted) | not)] | length" <<<"$comments_json")"
  echo "_${omitted} comment(s) from other people were left out._"
} > "$out/issue.md"
