---
name: model-results-chat
description: How to report model results to the user in chat, every time - the population with its numbers, who is included and who is excluded and why, the exposure and outcome, the model specification (type of model, strata, covariates, priors, fixed parameters), the fit and its convergence, then the estimates with their intervals and how they differ from the primary analysis. Use whenever a chat message reports an estimate, a refit, a sensitivity analysis, a comparison of models or the result of a background run (subagent, script or workflow), including short progress updates that quote a number. For reports and decks use quarto-epi-report and quarto-epi-deck.
---

# Reporting model results in chat

A number without its population and model cannot be followed. Every chat
message that reports a model result gives the context below, even when it
was given earlier in the conversation: the reader may come back to the
message alone, copy it to a colleague, or have lost track of which variant
is which. Project memory may add terminology and rules; follow those too.

## 1. What every result carries

Give these in this order, as short headed blocks or tables, before or
beside the estimates. Write "as the primary" for an item that is the same
as the primary analysis, and spell out only what differs, but never leave
an item out.

1. **Question.** One line: the estimand (for example VE against disease,
   VE against death once admitted) and why this fit was run (primary,
   sensitivity analysis, check, refit after a change).
2. **Data.** Source, data cut or linelist date, and the results file the
   numbers come from.
3. **Population.** Who is included, as the inclusion rules in plain words,
   with the numbers: total, and by outcome group (cases and controls,
   deaths and survivors) and by exposure, as "% (n/N)" with separate
   columns per outcome group.
4. **Exclusions.** Who is excluded at each step and why, with the count
   at each step, and where the excluded rows differ from the primary
   analysis. Say what happens to missing or unknown values (excluded,
   kept as a category, modelled).
5. **Exposure and outcome.** How each is defined and from which record
   (registry link, self-report, latent status), including timing rules.
6. **Model.** The type of model and how it is fitted (for example Bayesian
   conditional logistic regression in Stan, latent class model, Cox
   model, Mantel-Haenszel), then:
   - strata or matching (what defines a stratum, how many strata, how
     many are informative);
   - covariates, with how each is coded;
   - priors on every parameter, with their values (normal(0, 2) on the
     log odds ratio, Beta(12, 28) on link sensitivity), and any parameter
     fixed rather than estimated (link specificity fixed at 1);
   - random effects, dependence terms or other structure.
7. **Fit.** Chains and iterations if not the default, maximum R-hat,
   divergent transitions, effective sample size where it is low, and run
   time. Say plainly if a fit did not converge and whether it is used.
8. **Estimates.** Each estimate with its interval and the interval type
   (95% credible, 95% confidence), by population, next to the primary
   estimate for comparison, and on the same row the counts it rests on
   (see Counts beside every estimate below). Never a central estimate
   alone, including the ends of a range across analyses.
9. **What it changes.** One or two sentences: how the result differs from
   the primary and which choice explains the difference, then any caveat
   (few exposed cases, wide interval, a check that failed).

## 2. Format

- **Tables** for anything with more than two rows. Every column has a
  heading, including the row-label column, so the table copies cleanly.
- **Several variants at once:** one table with a column per item that
  differs (population, exposure, prior, strata) and the estimates in the
  last columns, so the difference between rows is visible without reading
  the prose. Put the primary as the first row. Before and after
  comparisons (two priors, two linelists) keep the counts columns; say
  whether the counts are the same in both and give both where they
  differ.
- **Counts** as "% (n/N)", cases and controls in separate columns.
- **Counts beside every estimate.** Every row of a results table that
  gives an estimate also gives its own counts, as "% (n/N)" in separate
  columns for the outcome groups: vaccinated test-positive cases of all
  cases and vaccinated test-negative controls of all controls, or
  vaccinated deaths of vaccinated patients and unvaccinated deaths of
  unvaccinated patients. This holds in comparison tables of many variants
  too, and for each population row, since variants that restrict the
  population, change the exposure or drop strata have counts different
  from the primary. Where the exposure is latent and has no observed
  count, give the cases and controls (or patients and deaths) included,
  and the observed counts of the records it rests on where the results
  hold them. Where the results file lacks the counts, write "not
  recorded" in the cell and say so, rather than leaving the column out.
  When a table has too many rows to show all of them with counts, show
  fewer rows rather than drop the counts.
- **Plain statements.** No framing sentences or colon reveals; no em
  dashes; UK English.
- **Length.** Complete but compact: a label and a few words per item. A
  short progress update still names the population, model and prior of
  any number it quotes.

## 3. Rules

- Read the specification from the code or the results file (the fitted
  call, the Stan program, the saved settings), not from memory. Where an
  item cannot be found, write "not recorded" and say where you looked.
- Report what the results file shows, not what the brief to a subagent
  asked for: check a subagent's or script's claims against the saved
  results before relaying them.
- Quote fitted estimates. Do not work out a crude estimate by hand from
  counts; offer to fit the model for that subgroup instead.
- Where data are sensitive, read only aggregate outputs; never open
  person-level rows to fill in a count.
- Results from observational data are associations; use the project's
  terms for them.
