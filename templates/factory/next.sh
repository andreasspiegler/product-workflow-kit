#!/usr/bin/env bash
# Continues a decomposed issue after one of its parts merged: starts the next sub-issue
# whose blockers are all closed, one at a time, or closes the parent once every
# sub-issue is done. Protected path: the factory must not change this file.
#
#   .factory/next.sh <issue-number>     (the merged sub-issue, or the decomposed parent)
#   Needs GH_TOKEN, GITHUB_REPOSITORY, and BASE (the default branch).
set -euo pipefail

issue="$1"
repo="$GITHUB_REPOSITORY"

parent="$(gh api "repos/$repo/issues/$issue/parent" --jq '.number' 2>/dev/null || true)"
[[ "$parent" =~ ^[0-9]+$ ]] || parent="$issue"   # gh prints the 404 body on stdout when there is no parent
if ! gh api "repos/$repo/issues/$parent" --jq '.labels[].name' | grep -qx 'factory:decomposed'; then
  echo "#$issue is not part of a decomposed factory issue."
  exit 0
fi

subs="$(gh api --paginate "repos/$repo/issues/$parent/sub_issues" | jq -s 'add // []')"
if [[ "$(jq '[.[] | select(.state == "open")] | length' <<<"$subs")" -eq 0 ]]; then
  printf '<!-- factory:finished -->\n**Factory:** All sub-issues of #%s are done.\n' "$parent" \
    | gh issue comment "$parent" --repo "$repo" --body-file -
  gh issue edit "$parent" --repo "$repo" --remove-label factory:decomposed --add-label factory:merged
  gh issue close "$parent" --repo "$repo" --reason completed
  exit 0
fi

# One part at a time: wait while a part is running or waiting for a person.
busy="$(jq '[.[] | select(.state == "open")
  | select(any(.labels[]?; .name | IN("factory:ready", "factory:running", "factory:needs-human", "factory:human-review")))] | length' <<<"$subs")"
if [[ "$busy" -gt 0 ]]; then
  echo "A sub-issue of #$parent is in progress; nothing to start."
  exit 0
fi

for n in $(jq -r '.[] | select(.state == "open") | .number' <<<"$subs"); do
  open_blockers="$(gh api "repos/$repo/issues/$n/dependencies/blocked_by" --jq '[.[] | select(.state == "open")] | length')"
  if [[ "$open_blockers" -eq 0 ]]; then
    gh workflow run factory.yml --repo "$repo" --ref "$BASE" -f issue="$n"
    echo "Started #$n."
    exit 0
  fi
done
echo "Every open sub-issue of #$parent is blocked."
