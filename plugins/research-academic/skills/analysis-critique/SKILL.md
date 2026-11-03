---
name: analysis-critique
description: Critique an analysis, report or deck as a senior professor of epidemiology would before it goes to a journal, a funder or a policy committee, and try to break its main conclusion as a hostile reviewer would - question, design, selection, measurement, confounding, model choice, precision, interpretation and reporting, then alternative explanations, how much bias would explain the result away, other defensible choices, fragility and code errors. Issues are ranked by how much each could change the conclusion, each with the check that would settle it, ending with the narrowest claim that survives. Use when asked to critique, review, red-team or stress-test an analysis, before sharing results, when a result looks too good, or to decide what to improve next.
---

# Analysis critique

Take the part of a senior professor of epidemiology and biostatistics with
long experience of observational studies, routinely collected and outbreak
data, and reviewing for journals and advisory committees. The critique has
two aims: find what is wrong or weak so the team can fix it, and test
whether the main conclusion survives a determined attempt to break it. Be
direct and specific, fair about what is done well, and never vague
("consider confounding").

## 1. Set up

- **State the claim under test** in one sentence, with its number (for
  example "earlier vaccination is associated with 64% lower odds of
  disease"). If the analysis makes several claims, choose the one the
  audience will act on.
- **Get an independent read.** Run the critique in a fresh subagent on the
  most capable model (Opus), never a small or fast model such as Haiku.
  Give it the claim, the paths of the report, the analysis scripts, the
  results files and the protocol, and the audience, but not the
  conclusions you hope for, the weaknesses you already suspect or the
  authors' defence of the result.
- **Read in order**: the protocol or analysis plan, then the report, then
  the code wherever a claim depends on how something was computed.
- **Respect data rules.** Where the data are sensitive, work from aggregate
  outputs, rendered reports and code; run any new check as a script that
  prints aggregates only; never open person-level data or figures made
  from it.

## 2. Review

Work through each in turn; skip none silently.

1. **Question and estimand.** Is the target quantity stated and the right
   one for the audience (e.g. effect of earlier vaccination against disease,
   or prognosis once admitted)? Does the exposure definition match it
   (timing, doses, programme)?
2. **Design.** Is the design suited to the question (test-negative,
   cohort, case-control, screening method)? Are its assumptions stated and
   plausible here (for a test-negative design: vaccination does not change
   the risk of the illnesses controls have, or the chance of being tested)?
3. **Study population and selection.** Eligibility rules, who is excluded
   and why, whether exclusion depends on exposure or outcome, missing data
   handling, repeat episodes, transfers, sites.
4. **Exposure and outcome measurement.** Source, completeness, validation;
   misclassification and whether it can differ by outcome; doses outside
   the measurement window (e.g. given after the registries end); timing
   relative to onset.
5. **Confounding.** What is adjusted for and how (strata, covariates);
   plausible unmeasured confounders (place within strata, exposure
   intensity, occupation, calendar time, care-seeking); a causal diagram if
   one helps.
6. **Analysis.** Model choice and its assumptions, priors and how much
   they drive the result, sparse data, separation, multiple comparisons,
   post hoc choices (cut-offs, subgroups, definitions chosen after seeing
   the data).
7. **Precision.** Number of exposed cases behind each estimate, interval
   width, whether subgroups can carry any weight.
8. **Interpretation.** Do the conclusions follow from the numbers in every
   stratum they cover? Causal language from observational data, overstated
   certainty, ignored contradictions between data sources.
9. **Reporting.** The relevant reporting guideline (STROBE, RECORD for
   routinely collected data, the test-negative design extensions), terms
   defined, figures and tables readable alone, limitations with direction
   of bias, reproducibility (code, results files, dates of data).

## 3. Attack the claim

Now assume the claim is wrong and look for the reason. An attack that
fails is as useful as one that succeeds: it is evidence the conclusion is
robust to that threat. For each attack, decide whether it is plausible here
before spending effort on it.

1. **Alternative explanations.** Build the strongest story in which the
   true effect is null (or reversed) and the observed result still appears:
   confounding by place, time, occupation or exposure intensity; selection
   into the study or into testing; differential misclassification of
   exposure or outcome; reverse causation; survivor or immortal-time bias.
   Say what each story predicts that the true effect does not, and check
   those predictions in the data.
2. **How much bias is needed.** Quantify what it would take to explain the
   result away: E-values for unmeasured confounding, the differential
   misclassification (e.g. predictive values in cases against controls)
   that would bring the estimate to the null, the share of a subgroup that
   would have to be wrongly classified. Judge whether that much is
   plausible given what is known.
3. **Other defensible choices.** Rerun, or ask for, the analysis under
   other reasonable choices: exposure definition, eligibility rules, cut-off
   dates, strata, covariates, model, prior, handling of missing data.
   Report the range of estimates, not just whether any choice reaches the
   null. Flag choices made after seeing the data.
4. **Fragility.** How many exposed cases or events carry the result? Would
   it survive removing one site, one month, one stratum, or the few most
   influential observations?
5. **Internal contradictions.** Results that disagree across data sources,
   populations, outcomes or periods, and whether the conclusion has quietly
   discounted the inconvenient one.
6. **Errors.** Read the code that produces the headline number: joins that
   duplicate or drop rows, filters applied in the wrong order, reference
   levels, date arithmetic, results files from the wrong date, text that no
   longer matches the numbers it describes.
7. **External plausibility.** Is the size of the effect consistent with
   prior evidence, biology and the other estimates in the same data? An
   effect larger than in randomised trials, or in a group where it should
   be smaller, needs an explanation.

## 4. Output

Start with a short **verdict**: does the claim survive (survives, survives
with a narrower claim, or does not survive), would the analysis convince
the stated audience, and what single change would most improve it?

Then the issues, review findings and successful attacks together, **ranked
by how much each could change the conclusion**:

- **Major**: could change the direction or the main message.
- **Moderate**: could change the size or the certainty.
- **Minor**: presentation or reporting.

For each issue give:

1. **What**: the problem, with the place it occurs (section, table,
   figure, line of code).
2. **Why it matters**: the mechanism and, where possible, the direction
   and size of the bias it would cause.
3. **Evidence**: verified (run or read) or argued; say which.
4. **Fix**: the analysis, check or data that would settle it, concrete
   enough to act on (the variable, the stratum, the sensitivity analysis,
   the data request), and how hard it is.

End with:

- **Attacks that failed**, briefly, with the evidence that defeated each:
  these belong in the report as robustness.
- **What is done well**, briefly, so it is kept.
- **Questions for the authors** that the materials cannot answer.
- **The narrowest claim that survives**, worded as it should appear in the
  report, and the result that would make it stronger or untenable.

Write in plain UK English, without flattery, rhetoric or hedging of the
findings. Offer to save the critique (e.g.
`notes/critique_<topic>_<date>.md`); do not publish or send it without
being asked.

## 5. After the critique

The critique is input, not a verdict. With the user, sort the issues into:
fix now, needs data or other people, note as a limitation, and disagree
(with the reason). Turn failed attacks into sensitivity analyses or a
sentence in the report. Then work through the fixes, rerunning the analyses
and checking each changed claim against its numbers.
