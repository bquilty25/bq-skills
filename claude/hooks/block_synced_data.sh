#!/bin/bash
# PreToolUse hook (local only: .claude/ is in this repo's .gitignore).
# Stops Claude Code reading, searching, editing or running commands on
# patient data or anything made from it: the synced OneDrive and SharePoint
# folders, and this repo's gitignored data and output folders (data/,
# data-raw/, data-prep/, local/, output/). The user runs the code; Claude
# works only on code and on results the user chooses to share.
#
# Checks the path fields of file tools and the full text of shell commands.
# Exit code 2 blocks the call and returns the message to Claude.
#
# The file name avoids the blocked words so that the hook itself can be
# maintained.

input=$(cat)

targets=$(printf '%s' "$input" | jq -r '
  .tool_input
  | [.file_path, .path, .notebook_path, .pattern, .glob, .command]
  | map(select(. != null))
  | join("\n")
')

synced='CloudStorage|OneDrive|SharePoint|SHAREPOINT_PATH|SharedLibraries'
folders='(^|[^A-Za-z0-9_.-])(data|data-raw|data-prep|local|output)(/|$|[[:space:]])'

if printf '%s' "$targets" | grep -Eiq "$synced|$folders"; then
  echo "Blocked by local hook (.claude/hooks/block_synced_data.sh): patient data and outputs made from it (synced folders, data/, data-prep/, local/, output/) must not be accessed directly. Ask the user to run the code and share results instead." >&2
  exit 2
fi

exit 0
