#!/bin/bash
# PreToolUse hook: Claude Code may not commit, push or open or merge a pull
# request without the user's review. Any shell command that does so is
# paused and the user is asked to approve it, whatever the session's
# permission mode.

input=$(cat)
command=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

if printf '%s' "$command" |
  grep -Eq '(^|[^A-Za-z0-9_-])git([[:space:]]+-[A-Za-z][^[:space:]]*([[:space:]]+[^-][^[:space:]]*)?)*[[:space:]]+(commit|push|merge|rebase|tag)([[:space:]]|$)|gh[[:space:]]+pr[[:space:]]+(create|merge)'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: "Git write (commit, push, merge, rebase, tag or pull request): review the changes before approving."
    }
  }'
fi

exit 0
