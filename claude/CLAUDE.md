# User-level instructions

Source of truth for Claude Code (`~/.claude/CLAUDE.md` links here) and GitHub Copilot (`~/.copilot/instructions/claude.instructions.md` points here). Edit this file in the bq-skills repo.

## Writing style

- Do not use em-dashes (—) in any written output. Use commas, colons, or rewrite the sentence instead.
- Do not use AI clichés such as "It's not just X, it's Y", "not just a tool, but a...", "diving into", "let's explore", "game-changer", "unleash", "powerful", "delve", "craft", "nuanced", or "at its core".
- Do not use hollow affirmations like "Certainly!", "Absolutely!", "Great question!", or "Of course!".
- Write plainly and directly. State facts without filler phrases.

## File editing

- **Never** use Python (`subprocess`, `pathlib.write_text`, script execution) or shell tools (`sed`, `awk`, `perl -i`) to replace, insert, or delete lines in a file.
- **Always** use the edit (string replace) tool directly for any file modification.
- This applies to all languages and all file types without exception.

## Data analysis principles

Analysis should be **reproducible**, **readable**, **efficient**, and **maintainable**, and report-driven: narrative, code, and results are integrated in Quarto documents, with functions kept separate from the analysis that uses them.

- **Paths**: use `here::here()` for every path, e.g. `read_csv(here::here("data", "raw", "my_data.csv"))`. Never use absolute paths, bare relative strings, or `setwd()`.
- **Vectorised operations**: use vectorised operations and `purrr::map_*()` by default. Loops are acceptable only for inherently sequential operations (e.g. stateful simulations, retry logic with side effects).
- **Modularity**: analysis scripts state the "what" and "why"; the "how" lives in functions stored in `scripts/functions/` and sourced where needed. This includes complex vectorised pipelines.
- **Style**: tidyverse style guide, `snake_case` names, and the native pipe `|>`. Use `dplyr` for manipulation, `ggplot2` for plots, `readr` for flat files, and `purrr` for iteration.
- **Storage**: save processed data and expensive intermediate results with `qs::qsave()` and read them with `qs::qread()`, rather than `.rds`.

## Project structure

- `data/raw/`: source data, never modified, and listed in `.gitignore`.
- `data/processed/`: cleaned or intermediate objects saved with `qs`.
- `scripts/`: numbered analysis scripts (`01_load_data.R`, `02_clean_data.R`, ...) in execution order, a `functions/` subfolder, and for multi-step pipelines an orchestrator (`00_run_pipeline.R`) that sources the numbered scripts in sequence as a single entry point.
- `outputs/`: plots, tables, and other pipeline results.

Never commit patient-identifiable or otherwise sensitive data. Keep `README.md` up to date when adding scripts or outputs or changing the pipeline structure.

## Quarto reports

The first chunk loads packages and sources functions; later chunks import with `here`, process with sourced functions and `dplyr` (saving with `qs`), analyse with `dplyr` and `purrr`, and report with `ggplot2` and inline code.

When writing Quarto documents, follow these priorities in order: 1) **Structure**: IMRaD (Abstract, Introduction, Methods, Results, Discussion with a concluding paragraph). 2) **Language**: UK English, prose paragraphs, no bullet points or lists. 3) **Voice**: precise and analytical scientific prose. 4) **Results section**: state findings only; all interpretation and commentary belongs in the Discussion.

**Register**: plain, measured scientific prose that matches the existing text. State findings directly and hedge where the evidence is limited. Do not use rhetorical questions, figurative or conversational phrasing, dramatic paragraph openers, or aphoristic closing sentences. When editing, preserve the author's wording and restructure or trim rather than restyle, unless explicitly asked to rewrite. When writing or editing manuscripts, apply the `academic-writing-standards` skill.

**Dynamic results**: every number in narrative text, abstracts, or captions that derives from data must be inline R code, never a typed literal, e.g. `` `r prettyNum(nrow(my_data), big.mark = ",")` ``. Required data must be asserted with `stopifnot()` rather than given fallback values (see the `quarto-dynamic-reporting` skill).
