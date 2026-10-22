# bq-skills

Private source of truth for personal AI skills, user-level instructions and
Claude Code hooks, used by Claude Code (the primary client), GitHub Copilot
and Antigravity. The repository started as a fork of the public
[`seabbs/skills`](https://github.com/seabbs/skills), kept as the `upstream`
remote, and adds personal and imported skills.

## Layout

| Path | Contents |
|---|---|
| `plugins/*/skills/*/SKILL.md` | Skills, grouped by plugin (see [All skills](#all-skills)) |
| `plugins/*/agents/` | Subagent definitions (`dev-workflow`, `productivity`) |
| `claude/CLAUDE.md` | User-level instructions |
| `claude/copilot.instructions.md` | Copilot wrapper for `claude/CLAUDE.md` |
| `claude/hooks/` | Claude Code hook scripts and settings |
| `scripts/link-user-skills.sh` | Links skills and instructions into each client |
| `.claude-plugin/`, `plugins/*/.claude-plugin/` | Marketplace manifests inherited from upstream |

## Setup

The canonical checkout is `~/.copilot/shared/bq-skills`:

```bash
git clone git@github.com:bquilty25/bq-skills.git ~/.copilot/shared/bq-skills
cd ~/.copilot/shared/bq-skills
git remote add upstream https://github.com/seabbs/skills.git
./scripts/link-user-skills.sh
```

The link script builds flat symlink views from every
`plugins/*/skills/*/SKILL.md` file:

- Claude Code: `~/.claude/skills`
- GitHub Copilot: `~/.copilot/skills`
- Antigravity: `~/.gemini/config/skills`

Rerun it after adding, removing or moving a skill. It checks for duplicate
skill folder names, builds the views before changing the live directories, and
stores the previous directories under `~/.ai-skills-backups/`. Entries in a
live directory that are not symlinks (e.g. Claude Code's `synced/` folder) are
carried over to the new view. Editing an existing skill needs no rerun, since
the views link to the files in this repository.

Each skill's `name:` field must be unique as well as its folder name: two
skills with the same `name:` hide one another. Imported skills keep their
upstream `name:` (e.g. `r-lib-cli` is invoked as `cli`).

Repository-local skills stay in their own project when they depend on
project-specific files or workflows.

To pull upstream changes: `git fetch upstream && git merge upstream/main`.

## User-level instructions

`claude/CLAUDE.md` holds the user-level instructions: writing style, file
editing, R data analysis principles, project structure and Quarto reporting.
The link script points `~/.claude/CLAUDE.md` at it, and points
`~/.copilot/instructions/claude.instructions.md` at
`claude/copilot.instructions.md`, which applies it to every file in Copilot.
Edit `claude/CLAUDE.md` here; both clients pick up the change in their next
session.

## Hooks

`claude/hooks/` holds Claude Code hooks, which the link script does not
install.

- `block_synced_data.sh` and `review_git_writes.sh` are project hooks for
  analyses of patient data. The first blocks Claude from reading, searching or
  running commands on synced OneDrive and SharePoint folders and on `data/`,
  `data-raw/`, `data-prep/`, `local/` and `output/`; the second asks for the
  user's approval before any commit, push, merge, rebase, tag or pull request.
  To use them in a project, copy both scripts to `.claude/hooks/` and merge
  `project-settings.json` into `.claude/settings.json`.
- `user-settings-hooks.json` is the `hooks` block of `~/.claude/settings.json`
  (a sound when Claude Code needs the user); merge it into that file on a new
  machine.

## Plugins

| Plugin | Skills | Description |
|---|---|---|
| `personal` | 4 | Own skills: writing, diagrams, Quarto reporting, refactoring |
| `research-academic` | 8 | Paper analysis, literature search, preprints, grants, minutes |
| `lang-r` | 1 | R package development (devtools, testthat, roxygen2) |
| `lang-julia` | 1 | Julia package development (SciML standards) |
| `lang-stan` | 1 | Stan probabilistic programming (cmdstanr) |
| `dev-workflow` | 12 | Commits, linting, testing, review, PRs, docs, coverage, deps, scaffolding, tasks |
| `github-ops` | 6 | Dashboard, issue management, repo analysis, issue scanning |
| `org-management` | 10 | CI health, deps, issues, maintenance, orchestration, releases, standards |
| `bot-automation` | 4 | Bot collaborator, task processing, daily summaries, PR quality gate |
| `productivity` | 8 | Code cleanup, Obsidian notes, tmux, news, weekly planning, sessions, inventory |
| `pi` | 1 | Delegate tasks to a local coding agent |
| `claude-imported` | 26 | Skills imported from Posit, r-lib, Quarto, Shiny and others |

**Total: 82 skills across 12 plugins**

## All skills

### personal

| Skill | Description |
|---|---|
| `/unslop` | Cut AI tells from any writing |
| `/diagram-design` | Design language for hand-authored SVG schematics (study designs, flows, timelines) |
| `/quarto-dynamic-reporting` | Inline R for every result in Quarto documents |
| `/refactor` | Refactor to project standards without changing behaviour |

### research-academic

| Skill | Description |
|---|---|
| `/academic-writing-standards` | Academic writing standards for peer-reviewed papers |
| `/analyzing-research-papers` | Systematic paper analysis and insight extraction |
| `/paper-summary` | Summarise a paper from URL, DOI, or file |
| `/preprint-search` | Search arXiv, medRxiv, bioRxiv for new preprints |
| `/literature-search` | Search bibliography files and Paperpile |
| `/grant-application-setup` | Set up grant application repositories |
| `/grant-compliance-checking` | Check work against grant requirements |
| `/minutes` | Create meeting minutes from a transcript |

### lang-r

| Skill | Description |
|---|---|
| `/r-development` | R package development (devtools, testthat, roxygen2) |

### lang-julia

| Skill | Description |
|---|---|
| `/julia-development` | Julia package development (SciML standards) |

### lang-stan

| Skill | Description |
|---|---|
| `/stan-development` | Stan probabilistic programming (cmdstanr) |

### dev-workflow

| Skill | Description |
|---|---|
| `/commit` | Create well-structured commits with conventional format |
| `/lint` | Lint, format, and optionally commit changes |
| `/test` | Run tests, fix failures iteratively, then commit |
| `/review` | Code review with linting and priority-ranked findings |
| `/docs` | Check and fix documentation gaps |
| `/pr` | End-to-end PR workflow from a GitHub issue |
| `/pre-pr-checks` | Full pre-PR verification in an isolated subagent |
| `/improve-coverage` | Identify test coverage gaps and generate tests |
| `/update-deps` | Review and update dependencies with incremental testing |
| `/project-organization` | Project scaffolding and structure patterns |
| `/show-diff` | Open diffview.nvim in a tmux split to review recent changes |
| `/taskfile-automation` | Task (taskfile.dev) automation for project workflows |

### github-ops

| Skill | Description |
|---|---|
| `/github-dashboard` | Notifications, PR status, issue triage |
| `/issue-summary` | Summarise a GitHub issue conversation |
| `/issue-reply` | Post a helpful reply to a GitHub issue |
| `/repo-summary` | Repository overview with activity metrics |
| `/repo-activity` | Recent repository activity analysis |
| `/scan-issues` | Find issues suitable for automated resolution |

### org-management

| Skill | Description |
|---|---|
| `/org-ci-health` | Scan CI status across org repos |
| `/org-deps` | Audit cross-repo dependencies |
| `/org-issues-do` | Scan for easy issues and resolve via PRs |
| `/org-issues-tidy` | Add clarity to open issues across repos |
| `/org-maintenance` | Clean up stale worktrees and unstick PRs |
| `/org-orchestrate` | Full org automation setup, scheduling, and execution |
| `/org-releases` | Check which packages are overdue for release |
| `/org-standards` | Scan for standards drift and propagate fixes |
| `/repo-watch` | Detect active repos not cloned locally |
| `/setup-scripts` | Generate helper scripts for org automation |

### bot-automation

| Skill | Description |
|---|---|
| `/add-bot` | Add bot account as repo collaborator |
| `/bot-tasks` | Process bot task requests from GitHub notifications |
| `/daily-summary` | Summarise Claude Code activity across repos |
| `/pr-automate` | Background quality gate after a PR is created or pushed |

### productivity

| Skill | Description |
|---|---|
| `/code-cleanup` | Audit and tidy code directory structure |
| `/conductor` | See what active Claude Code sessions are doing and message them |
| `/create-note` | Import markdown into Obsidian |
| `/format-note` | Format an Obsidian note with tags and daily link |
| `/tmux-workflow` | Tmux session management |
| `/uk-news` | UK news summary from BBC and Guardian |
| `/weekly-plan` | Review past week and suggest priorities |
| `/working-on` | Create or update a CLAUDE.md project inventory |

### pi

| Skill | Description |
|---|---|
| `/pi` | Delegate a self-contained task to pi, a local coding agent |

### claude-imported

| Skill | Invoked as | Description |
|---|---|---|
| `alt-text` | `/alt-text` | Alt text for figures in R packages and Quarto |
| `brand-yml` | `/brand-yml` | brand.yml branding for Shiny and Quarto |
| `connect-deploy-to-connect` | `/deploy-to-connect` | Deploy content to Posit Connect |
| `ggsql-ggsql` | `/ggsql` | ggsql grammar-of-graphics queries |
| `github-pr-create` | `/pr-create` | Create a PR and debug CI until it passes |
| `github-pr-threads-address` | `/pr-threads-address` | Work through unresolved PR review threads |
| `github-pr-threads-resolve` | `/pr-threads-resolve` | Bulk resolve addressed PR review threads |
| `open-source-create-release-checklist` | `/create-release-checklist` | Release checklist for an R package |
| `open-source-maintainer-decline` | `/maintainer-decline` | Draft replies declining issues or requests |
| `open-source-release-post` | `/release-post` | Package release blog posts |
| `posit-dev-critical-code-reviewer` | `/critical-code-reviewer` | Rigorous code and PR review |
| `posit-dev-describe-design` | `/describe-design` | Architecture documentation for a codebase |
| `posit-dev-implement` | `/implement` | Implement a plan file via parallel subagents |
| `posit-dev-new-work` | `/new-work` | Todo tracking documents for new work |
| `posit-dev-review-testing` | `/review-testing` | Review test quality and coverage |
| `posit-dev-working-on` | `/posit-dev-working-on` | Tracking document as source of truth for a task |
| `quarto-quarto-authoring` | `/quarto-authoring` | Quarto authoring and migration |
| `r-lib-cli` | `/cli` | The cli package for R |
| `r-lib-cran-extrachecks` | `/cran-extrachecks` | CRAN submission checks |
| `r-lib-lifecycle` | `/lifecycle` | Package lifecycle with the lifecycle package |
| `r-lib-mirai` | `/mirai` | Async and parallel R with mirai |
| `r-lib-r-cli-app` | `/r-cli-app` | Command-line apps in R with Rapp |
| `r-lib-r-package-development` | `/r-package-development` | R package development |
| `r-lib-testing-r-packages` | `/testing-r-packages` | testthat 3 testing |
| `shiny-shiny-bslib` | `/shiny-bslib` | Shiny apps with bslib |
| `shiny-shiny-bslib-theming` | `/shiny-bslib-theming` | Theming Shiny apps with bslib |

## Environment variables

Some skills use environment variables for personalisation:

| Variable | Used by | Purpose |
|---|---|---|
| `OBSIDIAN_VAULT` | `create-note`, `format-note` | Path to Obsidian vault |
| `GITHUB_HANDLE` | `org-orchestrate` | GitHub username for org automation |

## Licence

MIT
