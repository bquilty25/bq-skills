#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_root="${HOME}/.ai-skills-backups/$(date +%Y%m%d_%H%M%S)"
copilot_skills="${HOME}/.copilot/skills"
claude_skills="${HOME}/.claude/skills"
staging_root="$(mktemp -d "${TMPDIR:-/tmp}/link-user-skills.XXXXXX")"

trap 'rm -rf "${staging_root}"' EXIT

skill_list="${staging_root}/skills.tsv"
find "${repo_root}/plugins" -type f -name SKILL.md | sort | while IFS= read -r skill_file; do
  printf '%s\t%s\n' "$(basename "$(dirname "${skill_file}")")" \
    "$(dirname "${skill_file}")"
done > "${skill_list}"

skill_count="$(wc -l < "${skill_list}" | tr -d ' ')"
if [[ "${skill_count}" -eq 0 ]]; then
  printf 'No skills found under %s/plugins\n' "${repo_root}" >&2
  exit 1
fi

duplicate_names="$(cut -f1 "${skill_list}" | uniq -d)"
if [[ -n "${duplicate_names}" ]]; then
  printf 'Duplicate skill names:\n%s\n' "${duplicate_names}" >&2
  exit 1
fi

for client in copilot claude; do
  mkdir -p "${staging_root}/${client}-skills"
  while IFS=$'\t' read -r skill_name skill_dir; do
    ln -s "${skill_dir}" "${staging_root}/${client}-skills/${skill_name}"
  done < "${skill_list}"
done

mkdir -p "${backup_root}"

for client in copilot claude; do
  if [[ "${client}" == copilot ]]; then
    target="${copilot_skills}"
  else
    target="${claude_skills}"
  fi

  mkdir -p "$(dirname "${target}")"
  if [[ -e "${target}" ]]; then
    mv "${target}" "${backup_root}/${client}-skills"
  fi
  mv "${staging_root}/${client}-skills" "${target}"
done

printf 'Linked %d skills for Copilot and Claude.\n' "${skill_count}"
printf 'Previous skill directories backed up to %s\n' "${backup_root}"