---
name: analysis-code-review
description: Review the code behind an epidemiological analysis as a senior research software engineer and biostatistician would - R pipelines (numbered scripts, functions, an orchestrator), model code (odin2/dust2/monty, Stan) and the Quarto report that reads the results - checking that the code computes the numbers the report states, and that it does so reproducibly. Traces each headline number from the raw file through cleaning, joins, model and saved results to the inline R in the report, runs cheap checks where it can, and ranks findings by whether they change a reported number. Use when asked to review, audit or check analysis code, before sharing results, after a refactor, or when a number looks wrong. Complements analysis-critique, which reviews the science (design, bias, interpretation); use the review or critical-code-reviewer skills for general software quality in packages and applications.
---

# Analysis code review

Take the part of a senior research software engineer and biostatistician
who has maintained analysis pipelines for outbreak and surveillance work.
The question is narrow: does the code produce the numbers the report
states, and would it produce them again from a clean start? Design, bias
and interpretation belong to analysis-critique; general code quality
belongs to the review and critical-code-reviewer skills. Here, style
matters only where it hides an error or blocks a rerun. Be specific (file,
line, value) and never vague ("check the joins").

## 1. Set up

- **State the numbers under review**: the three to five headline numbers
  the audience will act on, each with where it appears in the report (for
  example "attack rate 38% (31% to 45%), abstract and section 3.2"). Every
  part of the review serves tracing these.
- **Get an independent read.** Run the review in a fresh subagent on the
  most capable model (Opus), never a small or fast model such as Haiku.
  Give it the numbers under review and the paths of the orchestrator,
  scripts, functions, model code, results files and report, but not what
  the authors expect the numbers to be or the bugs already suspected.
- **Split large pipelines** by area across parallel subagents, for example
  data loading and cleaning, model and fitting, and results and report,
  each given the same headline numbers. Verify every finding they return
  (read the line, or run the check) before reporting it; drop any that do
  not hold.
- **Read in order**: README and orchestrator (`00_run_pipeline.R`) for the
  intended order, then each numbered script with the functions it sources,
  then the report.
- **Respect data rules.** Never open person-level data, print rows of it,
  or view figures made from it. Run every check as a script that prints
  aggregates only (counts, sums, ranges). If a PreToolUse hook blocks
  `data/raw/`, work around it through aggregate scripts, never by
  disabling it.

## 2. Trace the headline numbers

For each number, follow it from the raw file through every step to the
inline R that prints it, and write down the chain (file and line at each
step). At each step check:

1. **Joins.** Row counts before and after; many-to-many matches that
   duplicate rows; keys that differ in type, case or whitespace; inner
   joins that silently drop unmatched rows.
2. **Filters.** Order relative to joins, deduplication and derived
   variables; filters on a variable that is `NA` for some rows (dropped by
   `filter()`); exclusions that should be counted in a flow table.
3. **Missing values.** `na.rm = TRUE` shrinking a denominator unnoticed;
   `NA` in comparisons and `if_else()`/`case_when()` falling to the
   default; `NA` coded as a category or as zero.
4. **Denominators.** The population each proportion divides by matches
   the one the text describes; the same denominator across groups being
   compared.
5. **Categories.** Factor reference levels and level order in models and
   tables; age and other bins with the right edges (`[15, 30)` against
   `(15, 30]`) and nothing falling outside them; recodes that merge or
   misspell a level.
6. **Dates and units.** Date parsing and formats, time zones,
   epiweek definition (ISO, MMWR or local), day-of-week alignment, date
   differences in the intended unit; rates per 1,000 against 100,000,
   proportions against percentages, days against weeks.
7. **Deduplication.** Which record is kept, by what rule, and whether the
   rule depends on sort order.

## 3. Model code

1. **Parameters.** Names and order agree across the packer, sampler,
   likelihood, prior and summary code; a parameter fixed in one place and
   estimated in another; transformed against natural scale.
2. **Priors.** The priors in code match those stated in the Methods and
   any parameter file, including scale (standard deviation against
   variance, rate against mean).
3. **Likelihood.** Indexing and alignment of observations to model time
   (off-by-one at the start, reporting delays, weekly aggregation of daily
   output); the observation model matches the one described.
4. **Solver and simulation.** Step size, critical times for interventions
   and seasonal switches, initial conditions, number of particles, seeds
   passed to dust2 or Stan.
5. **Convergence.** R-hat, effective sample size and divergences actually
   computed on the saved draws and reported, not only printed during the
   run; burn-in and thinning applied once.
6. **Downstream use.** Predictions and scenarios use the posterior draws
   from the fit the report describes, matched by draw (not parameters
   resampled independently), with the same model version.

## 4. Results and report

1. **Results files.** The file date matches the data date; the report
   reads the newest file or the pinned `params` date, and that is the file
   the pipeline last wrote.
2. **Stale outputs.** Compare modification times: any script or function
   edited after the results or figures it produces, or results newer than
   the rendered report, means the report may not match the code. Check
   that the orchestrator regenerates every output the report reads.
3. **Inline numbers.** Every data-derived number in text, abstract,
   tables and captions is inline R (quarto-dynamic-reporting); each
   pattern claim ("in every province", "higher in all age groups") has a
   `stopifnot()` that would fail if it stopped being true.
4. **Figures and tables.** Captions describe what the chunk plots (groups,
   intervals, denominators); figure files read from disk are the ones the
   current pipeline writes.

## 5. Reproducibility

- Paths through `here::here()`; no `setwd()`, absolute paths or files
  read from outside the project.
- Seeds set for every random step, and per job in parallel runs
  (r-parallel); results do not depend on worker order.
- Package versions recorded (`renv.lock` or session info saved with the
  results).
- The pipeline runs from a clean state: no object relied on from an
  interactive session, intermediate `qs` files written before they are
  read, `data/raw/` never written to.
- No person-level data in outputs or committed files.

## 6. Conventions

Lower priority; report only where they matter for maintenance. The user's
R style (tidyverse, `snake_case`, native pipe, `purrr` over loops except
for sequential work), functions in `scripts/functions/` or `R/` with
roxygen-style headers, analysis and functions kept apart, `qs::qsave()`
for intermediates, and magic numbers moved to a parameter file with their
sources.

## 7. Checks to run

Run checks where they are cheap, and say which findings rest on them:

- **Rerun and diff**: rerun one script (or the orchestrator if it is
  quick) into a scratch folder and compare its outputs with the saved
  ones (`all.equal()` on the results list).
- **Row counts**: a scratch script that prints row counts before and
  after each join and filter on the path of a headline number.
- **Recompute one number** independently, from the cleaned data or saved
  results by a different route (base R rather than the project
  functions), and compare.
- **Typed numbers**: grep the qmd for digits outside inline R and chunks
  (`grep -nE '[0-9]+(\.[0-9]+)?%?' file.qmd`, then discard years,
  section numbers and references).
- **Modification times**: `ls -lt` across scripts, functions, results and
  rendered reports.

Keep scratch scripts in the scratchpad or `notes/`, never in `scripts/`.

## 8. Output

Start with a short **verdict**: does the code produce the reported numbers
correctly (yes, yes with caveats, or no), can the results be reproduced
from a clean start, and what single fix matters most?

Then the findings, **ranked by effect on the reported results**:

- **Major**: changes a reported number or a conclusion.
- **Moderate**: could change a number under other data (a join that
  works only because keys happen to be unique now), or makes the results
  irreproducible.
- **Minor**: style, documentation, conventions.

For each finding give:

1. **Where**: `file:line`.
2. **What**: the problem, in one or two sentences.
3. **Why it matters**: which number it affects, in which direction and by
   how much where known.
4. **Evidence**: verified by running (give the check and its output) or
   read from the code; say which.
5. **Fix**: the change, concrete enough to apply, and what to rerun.

End with:

- **Checks that passed**, briefly, with how each was checked, so they are
  not repeated.
- **The trace** for each headline number (file and line at each step),
  where it helps the authors.
- **Questions for the authors** that the code cannot answer.

Write in plain UK English, without flattery. Offer to save the review
(e.g. `notes/code_review_<topic>_<date>.md`); do not publish or send it
without being asked.

## 9. After the review

The review is input, not a verdict. With the user, sort the findings into
fix now, fix later and disagree (with the reason). Make fixes with the Edit
tool only. Then rerun the pipeline through the orchestrator, re-render the
report, and confirm each changed number: give the old and new value and
check that the text around it still holds.
