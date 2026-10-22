---
name: refactor
description: Refactor code to project standards without changing behaviour, verifying outputs before and after
argument-hint: [commit|pr|all|path]
---

Refactor code to project standards without changing behaviour.

Arguments: $ARGUMENTS (optional scope)
  - commit: Refactor only staged files
  - pr: Refactor all files changed in the current PR
  - all: Refactor the entire codebase
  - path: Refactor a specific file or directory
  - If no argument provided:
    - If in a PR branch: defaults to 'pr'
    - Otherwise: defaults to 'commit'

## Phase 1: Scope and Baseline
1. Determine scope based on $ARGUMENTS
2. Extract project standards from CLAUDE.md and any project skills
   (e.g. `r-analysis-standards`)
3. Record a behavioural baseline before changing anything:
   - Run the test suite if one exists
   - For analysis pipelines without tests, run the affected numbered
     scripts and save key outputs to the scratchpad with `qs::qsave()`
     for later comparison
   - If a baseline cannot be established, say so and ask before proceeding

## Phase 2: Identify Refactoring Targets
4. Review in-scope code for:
   - Repeated logic that belongs in a function under `scripts/functions/`
   - Explicit loops that should be vectorised or use `purrr::map_*()`
     (keep loops for inherently sequential work)
   - Absolute paths, bare relative paths, or `setwd()` instead of
     `here::here()`
   - `saveRDS()`/`readRDS()` for intermediate objects instead of `qs`
   - Non-tidyverse style: `%>%` instead of `|>`, non-snake_case names,
     lines over 80 characters
   - Hardcoded numbers in Quarto text that should be inline R
   - Fallback values for required data that should be `stopifnot()`
   - Dead code, unused functions, and stale comments
   - Scripts out of numbered order or missing from the orchestrator
5. Present a prioritised list of proposed changes and confirm scope with
   the user if the changes are large or touch many files

## Phase 3: Apply Refactoring
6. Make changes in small, independent steps using the edit tool only
   (never `sed`, `awk`, `perl -i`, or Python to rewrite files)
7. Match the surrounding code: naming, comment density, and idiom
8. Do not change model specifications, priors, statistical methods, or
   outputs as part of a refactor. Flag suspected bugs separately instead
   of fixing them silently

## Phase 4: Verification
9. Re-run tests or affected scripts after each logical group of changes
10. Compare outputs against the Phase 1 baseline (`all.equal()` or
    `waldo::compare()`); any difference is a regression to fix or report
11. Run `/lint` on changed files
12. Update `README.md` if scripts, functions, or the pipeline structure
    changed

## Phase 5: Commit and Report
13. Stage changes and generate commit message:
    - `refactor(scope): description`
14. Summary of changes made, verification results, and any suspected
    bugs or deferred items

If verification fails and the cause cannot be resolved, revert that step,
report it clearly, and stop before committing.

## Auto-Exit When Standalone
**IMPORTANT**: If this command is being run as a standalone request, automatically exit after completing all phases successfully.
