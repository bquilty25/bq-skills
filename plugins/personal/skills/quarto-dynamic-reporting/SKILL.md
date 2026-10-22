---
name: quarto-dynamic-reporting
description: Strict requirement for dynamic inline R code for all results, metrics, and data summaries in Quarto documents. Zero hardcoding tolerance.
---

# Quarto Dynamic Reporting: Zero Hardcoded Results

All quantitative findings, metrics, counts, proportions, percentages, timings, and data characteristics in Quarto (`.qmd`) documents must be dynamically generated from data using inline R code (`` `r ...` ``).

## Core Rules

1. **No Static Result Literals**: Never write hardcoded numbers in narrative text, abstracts, tables, or figure captions for results that originate from data (e.g., F1 scores, case counts, recall, precision, ARI, p-values, runtimes, dates).
2. **No Mock Dynamic Fallbacks**: Never use `if (file.exists(...)) { ... } else { n <- 54L }`. If data is required, assert it with `stopifnot("Data file missing" = file.exists(...))` so the document fails loudly if data is absent.
3. **Helper Functions Over Repeated Queries**: If a metric is queried multiple times or needs formatting (e.g. `scales::percent(..., accuracy = 0.1)`), define a clean helper function in the document's setup chunk or a sourced script in `scripts/`.
4. **Self-Audit**: Before finalizing any `.qmd` edit, scan the prose for raw numbers, percentages (`%`), or metric strings (`F1`, `ARI`) that lack `` `r ...` `` wrappers.

## Patterns to Detect and Fix

| Anti-pattern | Violation | Correct Dynamic Form |
|---|---|---|
| `recovered 51 of 54 cases` | Static case counts | ``recovered `r n_matched` of `r n_total` cases`` |
| `F1 reached 94.0%` | Hardcoded percentage | ``F1 reached `r scales::percent(f1_val, accuracy = 0.1)``` |
| `took 74% less time` | Hardcoded timing comparison | ``took `r round((1 - t_model / t_ref) * 100)`% less time`` |
| `cluster ARI of 0.82` | Hardcoded metric | ``cluster ARI of `r scales::number(ari_val, accuracy = 0.01)``` |
| `else { n <- 54L }` | Mock dynamic fallback | Assert with `stopifnot(file.exists(...))` |
