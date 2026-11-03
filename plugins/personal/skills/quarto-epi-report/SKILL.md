---
name: quarto-epi-report
description: How to build an Epicentre (MSF) epidemiological analysis report in Quarto from start to finish, the way the user wants every time - an analysis script that saves aggregate results, a report that only reads them, the Epicentre epitemplates report formats, text helpers for the few numbers each claim needs, tables and figures whose captions say who each group holds, IMRaD prose with a fixed structure, and checks of the render before calling it done. Use when creating a new Quarto report, adding a section, table or figure to one, or restructuring one. For slide decks use quarto-epi-deck. Builds on quarto-dynamic-reporting (inline numbers) and academic-writing-standards (prose).
---

# Quarto epidemiological reports (Epicentre)

A report is three files: functions in `R/<topic>.R`, an analysis script in
`scripts/<topic>.R` that computes and saves aggregates, and a `.qmd` under
`qmd/` (in a topic folder where the project has them) that reads them and
writes the text. A deck that summarises the report follows quarto-epi-deck
and reads the same results.

**Start every new report from `templates/report.qmd` in this skill's
folder**: copy it to `qmd/<topic>/<topic>.qmd` and replace each `<...>`. It
holds the Epicentre front matter, the setup chunk with the formatting
helpers and the results check, and the IMRaD skeleton with a table and a
figure chunk. When adding to an existing report, follow that report instead. Also apply `quarto-dynamic-reporting`
(every data-derived number is inline R) and `academic-writing-standards`
(prose). Project memory may add terminology, audience and sharing rules;
follow those too.

## 1. Architecture

- **The analysis script does the work.** It loads and prepares the data,
  calls functions from `R/`, prints short aggregate summaries to the log,
  and exports one list of aggregate results, for example
  `output/fits/res_<topic>_<date>.rds`, dated by the data it was run on
  (the upload or export date, not today). Record source file names in a
  `sources` element so the report can name them.
- **The report fits nothing.** It reads the newest results file (or a date
  pinned in `params`), checks with `stopifnot()` that the file exists and
  holds every element it uses, and fails loudly otherwise. If the project
  resolves "latest" through a registry of report names and file prefixes,
  add the new report to it.
- **Only aggregates leave the script**: counts, proportions, estimates and
  intervals, never person-level rows. Where the data are sensitive, never
  open person-level data or figures made from it; check outputs through
  aggregate printouts and the rendered text.
- **Functions are generic and documented** with a roxygen-style header
  saying what goes in, what comes out, and any definition a reader needs
  (who is included, how a category is coded). Strata are an argument
  (`by = character()`), so one function serves overall, by province and by
  subgroup.
- Number scripts or add an orchestrator only if the project already does.
  Update the README when adding a script or report.

## 2. Epicentre format

Reports use the Epicentre house style from the
[`epitemplates`](https://github.com/epicentre-msf/epitemplates) Quarto
extension, kept in `_extensions/epicentre-msf/` at the project root.

- **Formats.** `epitemplates-report-html` (with `grid: body-width: 1000px`)
  and `epitemplates-report-docx: default`.
- **Front matter of a report**, as in the project's existing reports: title
  (no commas), a subtitle that ends "Epicentre, Paris", `footer: Epicentre -
  Médecins Sans Frontières`, `date: last-modified` with `date-format: long`,
  `toc: true`, `number-sections: true`, the project bibliography and
  `the-lancet.csl` (paths relative to the document), `execute: echo: false,
  warning: false, message: false`, and `params` for the results date
  (`res_date: "latest"`) and folder. Copy the `include-in-header` style block
  (body font size, link colour, title sizes) from an existing report.
- **Render list.** Every report is listed in the render list of
  `_quarto.yml`; documents in a subfolder find the Epicentre format only
  when listed. Sharing (e.g. to SharePoint) is a separate list; add a
  document to it only when the user asks.
- **Font and figures.** Text in figures uses the template font through
  showtext (`knitr::opts_chunk$set(fig.showtext = TRUE)` and the project's
  font helper, e.g. `epi_font()`), and forest plots use the project's helper
  (e.g. `forest_ve()`), so figures match across reports and decks.
- **Colours.** Epicentre orange (`#eb6834`) and blue (`#5b7fa6`, header
  blue `#2E569E`) for the two main series (datasets or exposures), greys for
  reference groups; keep one colour per series across a report and its
  deck.
- **Word output** must open without repair; where the project post-processes
  the docx (e.g. `scripts/fix_docx.R` as a post-render step), keep it in
  place.

## 3. Setup chunk

The first chunk loads packages, sources the table and figure helpers, reads
the results and defines small formatting helpers. Typical set:

```r
pct <- function(x, digits = 0) {
  sub("-", "−", sprintf(paste0("%.", digits, "f%%"), x), fixed = TRUE)
}
num <- function(x) scales::comma(x, accuracy = 1)
ci <- function(est, lo, hi) sprintf("%s (%s to %s)", pct(est), pct(lo), pct(hi))
pval <- function(p) {
  case_when(is.na(p) ~ "not testable", p < 0.001 ~ "p < 0.001", .default = sprintf("p = %.3f", p))
}
# the single row of `d` matching the filters, or an error
one_row <- function(d, ...) {
  out <- filter(d, ...)
  stopifnot(nrow(out) == 1)
  out
}
```

Then one text helper per quantity the prose cites, built on `one_row()`, that
returns the claim with its counts, for example `"55% (46 of 83)"` or
`"64% (41% to 79%)"`. Rules:

- A helper looks up exactly one row and errors otherwise; it also errors
  on an empty denominator, so the text never shows `NaN%` or `NA`.
- Percentages of small shares get one decimal (`0.5%`, not `0%`).
- Use a true minus sign for negative values.
- Short keys map to the long labels stored in the results
  (`c(msf = "MSF linelist", dhis2 = "DHIS2 surveillance")`), so prose reads
  `` `r mt("msf", "Sensitivity", province = "Nord Kivu")` ``.
- Assertions that the text relies on go in the setup chunk, for example
  `stopifnot(all(confirmed < mean_posterior))` before writing "in every
  band, the share confirmed was below the mean posterior".

## 4. Tables

- Use the project's table helper (for example `epi_gt()`) with group rows
  for strata and a notes argument for definitions and abbreviations.
- Cells give the estimate with its interval and counts:
  `55% (44% to 66%); 46/83`, or `n (%)` for descriptive tables.
- Order rows and groups explicitly with factors; never rely on alphabetical
  order.
- The caption says what is counted, among whom, and what each cell holds:
  "People with a validated registry link, by self-reported status and
  province, cases and controls together: linked / people (%)."
- Notes define every term, abbreviation and inclusion rule a reader needs
  to read the table alone.

## 5. Figures

The caption must explain the groups. A reader who sees only the figure and
its caption should know:

- **who each panel, row, column or colour holds**, including whether
  populations are nested (a combined population and the subgroups that
  make it up) and whether rows use the same people or different ones;
- **why rows within a group differ** (only the model, only the source of the
  exposure, a different definition that leaves people out);
- **what the side columns and labels count**, and their denominators;
- what the marks mean (point and interval type, filled against open
  symbols, arrows for intervals past the axis) and the axis scale.

Group headings inside the figure say who the group holds ("Combined
population: general population and FLW together"), not a bare label.
When two rows share a label, add a column that tells them apart (for
example "Patients: all eligible" against "Patients: self-reported yes or
no"). Keep one colour per data source or exposure across all figures in a
report. Prefer facets with explicit strips and `fct_rev()`d factors to
control order. Size figures (`fig-width`, `fig-height`) for the number of
rows they hold.

## 6. Prose and structure

IMRaD, UK English, prose paragraphs without bullets, first person plural.
Results state findings only; interpretation goes in the Discussion. Number
sections and include a table of contents.

**Abstract**, labelled Background, Methods, Results, Conclusions. Results
give only the main estimates with their intervals and the one contrast that
matters most; Conclusions say what the reader should take away, hedged to
the evidence.

**Introduction**: what is known, what is missing and why it matters, ending
with one sentence that starts "In this study, we aimed to ...".

**Methods**, past tense, under Study design, Data sources, Study
populations and Statistical analysis (add or drop subsections only where
the content needs it). Define every group, outcome, exposure and measure
the Results use, including how unknown or missing values are handled.

**Results**, one subsection per question. Each paragraph makes its claims
with the few numbers they rest on, and leaves the rest to its table or
figure; the text reads as findings, not a table written out as prose.

- One to three numbers per paragraph: the headline estimate with its
  interval and, where it matters, the one contrast the claim rests on.
- Counts only where they change how a number reads (for example, "from 2
  vaccinated cases" explains a wide interval); otherwise they belong in the
  tables.
- Summarise strata rather than listing them: "between 63% and 66% in every
  group (Table 2)", not every population's estimate in turn.
- A number appears in the text once; the Discussion repeats one only to
  interpret it.

Every number that does appear is still inline R (quarto-dynamic-reporting),
and a claim about a pattern ("similar in cases and controls") is backed by an
assertion in the setup chunk if its numbers are not in the sentence. Cite
every table and figure in the sentence that uses it. Vary sentence length; a mix of short and longer sentences is good
as long as each is easy to follow. Avoid long semicolon chains with inline
R fragments spliced in; keep a conditional inline result as a whole
sentence rather than a mid-sentence fragment. Every sentence says which
estimate it means; never "the estimate" or "it" across sentences.

**Discussion**, in this order:

1. "We found that ..." with the main numbers.
2. Comparison with other evidence, each statement referenced.
3. A strengths paragraph.
4. "Our study has several limitations. First, ... Second, ..." Each
   limitation says the direction of the bias where it can, and what would
   resolve it.
5. A closing paragraph that starts "Overall, we found ...", states the
   conclusion and its consequence for the reader, and ends there, without
   an aphorism.

Every statement that is not the report's own result needs a reference from
the project bibliography, checked against Crossref or the publisher, or must
be labelled unpublished. Use the project's citation style and bibliography
file.

**Register**: plain, measured and specific. No rhetorical questions,
dramatic openers or figurative phrasing; no em dashes. Write for the
report's stated audience: for readers outside the team, define terms and do
not mention scripts, file names of code, internal people or internal
process.

## 7. Checks before calling it done

1. Run the analysis script and confirm it exits cleanly.
2. Render the report (skipping any automatic sharing while drafting) and
   confirm it exits cleanly.
3. Search the rendered HTML text, outside embedded images, for `NA`, `NaN`,
   `Inf` and empty parentheses.
4. Extract and read the rendered Abstract, Results and Discussion as text.
   Check each interpretive claim against the numbers beside it, in every
   stratum it covers: a claim true overall can be false in one subgroup.
   Rewrite or remove any claim the numbers do not support.
5. Check figure and table captions against what the chunk actually plots,
   including the order and grouping of rows.
6. Scan the prose for typed numbers that should be inline R, and for
   paragraphs that list more numbers than their claims need.
7. Report to the user what the report contains, the definitions chosen
   that they may want to revisit, and anything not yet shared or
   committed.
