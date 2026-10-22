#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_root="${HOME}/.ai-skills-backups/$(date +%Y%m%d_%H%M%S)"
copilot_skills="${HOME}/.copilot/skills"
claude_skills="${HOME}/.claude/skills"
antigravity_skills="${HOME}/.gemini/config/skills"
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

for client in copilot claude antigravity; do
  mkdir -p "${staging_root}/${client}-skills"
  while IFS=$'\t' read -r skill_name skill_dir; do
    ln -s "${skill_dir}" "${staging_root}/${client}-skills/${skill_name}"
  done < "${skill_list}"
done

mkdir -p "${backup_root}"

for client in copilot claude antigravity; do
  if [[ "${client}" == copilot ]]; then
    target="${copilot_skills}"
  elif [[ "${client}" == claude ]]; then
    target="${claude_skills}"
  else
    target="${antigravity_skills}"
  fi

  mkdir -p "$(dirname "${target}")"
  # carry over entries that are not skill links (e.g. Claude Code's synced/)
  if [[ -d "${target}" ]]; then
    for entry in "${target}"/* "${target}"/.[!.]*; do
      [[ -e "${entry}" && ! -L "${entry}" ]] || continue
      [[ -e "${staging_root}/${client}-skills/$(basename "${entry}")" ]] && continue
      cp -R "${entry}" "${staging_root}/${client}-skills/"
    done
  fi
  if [[ -e "${target}" ]]; then
    mv "${target}" "${backup_root}/${client}-skills"
  fi
  mv "${staging_root}/${client}-skills" "${target}"
done

for instructions in "${HOME}/.claude/CLAUDE.md" \
  "${HOME}/.copilot/instructions/claude.instructions.md"; do
  mkdir -p "$(dirname "${instructions}")"
  if [[ -e "${instructions}" && ! -L "${instructions}" ]]; then
    mv "${instructions}" "${backup_root}/$(basename "${instructions}")"
  fi
done
ln -sfn "${repo_root}/claude/CLAUDE.md" "${HOME}/.claude/CLAUDE.md"
ln -sfn "${repo_root}/claude/copilot.instructions.md" \
  "${HOME}/.copilot/instructions/claude.instructions.md"

printf 'Linked %d skills for Copilot, Claude, and Antigravity.\n' "${skill_count}"
printf 'Linked user-level instructions (claude/CLAUDE.md).\n'
printf 'Previous skill directories backed up to %s\n' "${backup_root}"