#!/usr/bin/env bash
# Writes the trusted issue context for the factory's agents to <out-dir>/issue.md:
# the issue itself, comments from people with write access, and the factory's own
# comments. For a sub-issue, the parent issue follows in the same form. Everything
# else is left out, so outside text cannot steer the agents.
# Protected path: the factory must not change this file. Edit it by hand.
#
#   .factory/context.sh <issue-number> <out-dir>     (needs GH_TOKEN and GITHUB_REPOSITORY)
set -euo pipefail

issue="$1"
out="$2"
mkdir -p "$out"

trusted='(.author_association | IN("OWNER", "MEMBER", "COLLABORATOR")) or (.user.login == "github-actions[bot]" and ((.body // "") | contains("<!-- factory:")))'

# Prints one issue with its trusted comments, headed at the given Markdown level.
render() {
  local number="$1" heading="$2" issue_json comments_json omitted
  issue_json="$(gh api "repos/$GITHUB_REPOSITORY/issues/$number")"
  comments_json="$(gh api --paginate "repos/$GITHUB_REPOSITORY/issues/$number/comments" | jq -s 'add // []')"
  jq -r --arg h "$heading" '"\($h) #\(.number): \(.title)\n\nOpened by @\(.user.login) (\(.author_association)).\n\n\(.body // "")\n"' <<<"$issue_json"
  echo "$heading# Comments from people with write access and from the factory"
  echo
  jq -r ".[] | select($trusted) | \"$heading## @\\(.user.login), \\(.created_at)\n\n\\(.body)\n\"" <<<"$comments_json"
  omitted="$(jq "[.[] | select(($trusted) | not)] | length" <<<"$comments_json")"
  echo "_${omitted} comment(s) from other people were left out._"
}

parent="$(gh api "repos/$GITHUB_REPOSITORY/issues/$issue/parent" --jq '.number' 2>/dev/null || true)"
[[ "$parent" =~ ^[0-9]+$ ]] || parent=""   # gh prints the 404 body on stdout when there is no parent
{
  render "$issue" "#"
  if [[ -n "$parent" ]]; then
    echo
    echo "# Parent issue"
    echo
    echo "This issue is one part of a decomposition. Build only this part; the parent holds the problem, non-goals, and answers."
    echo
    render "$parent" "##"
  fi
} > "$out/issue.md"
