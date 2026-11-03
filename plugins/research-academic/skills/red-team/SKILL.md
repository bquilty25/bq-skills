---
name: red-team
description: Red-team an analysis - try to break its main conclusion the way a hostile reviewer, a sceptical policy committee or a competing group would - by building the strongest alternative explanations, quantifying how much bias each would need to explain the result away, rerunning it under other defensible choices, and hunting for errors in the code and data handling. Reports which attacks succeed, which fail and why. Use before results are presented or published, when a result looks too good or too convenient, or when asked to red-team, stress-test or attack an analysis. For a balanced review aimed at improving the analysis, use analysis-critique.
---

# Red team

The red team's job is to make the main conclusion fail. A critique asks how
to improve an analysis; the red team assumes the conclusion is wrong and
looks for the reason. An attack that fails is as useful as one that
succeeds: it is evidence the conclusion is robust to that threat.

## 1. Set up

- **State the claim under attack** in one sentence, with its number (for
  example "earlier vaccination is associated with 64% lower odds of
  disease"). If the analysis makes several claims, attack the one the
  audience will act on.
- **Work independently of the authors.** Prefer a fresh subagent on the
  most capable model (Opus), never a small or fast model such as Haiku, given the
  claim, the report, the scripts, the results files and the protocol, but
  not the authors' defence of the result.
- **Respect data rules.** Where the data are sensitive, work from aggregate
  outputs and code; run new checks as scripts that print aggregates only;
  never open person-level data or figures made from it.

## 2. Attacks

Work through each family; for each attack, decide whether it is plausible
here before spending effort on it.

1. **Alternative explanations.** Build the strongest story in which the
   true effect is null (or reversed) and the observed result still appears:
   confounding by place, time, occupation or exposure intensity; selection
   into the study or into testing; differential misclassification of
   exposure or outcome; reverse causation; regression to the mean;
   survivor or immortal-time bias. Say what each story predicts that the
   true effect does not, and check those predictions in the data.
2. **How much bias is needed.** Quantify what it would take to explain the
   result away: E-values for unmeasured confounding, the differential
   misclassification (e.g. predictive values in cases against controls)
   that would bring the estimate to the null, the share of a subgroup that
   would have to be wrongly classified. Judge whether that much is
   plausible given what is known.
3. **Other defensible choices.** Rerun, or ask for, the analysis under
   other reasonable choices: exposure definition, eligibility rules, cut-off
   dates, strata, covariates, model, prior, handling of missing data. Report
   the range of estimates, not just whether any choice reaches the null.
   Flag choices made after seeing the data (forking paths).
4. **Fragility.** How many exposed cases or events carry the result? Would
   it survive removing one site, one month, one stratum, or the few most
   influential observations?
5. **Internal contradictions.** Results that disagree across data sources,
   populations, outcomes or periods, and whether the conclusion has quietly
   discounted the inconvenient one.
6. **Errors.** Read the code that produces the headline number: joins that
   duplicate or drop rows, filters applied in the wrong order, reference
   levels, date arithmetic, unit errors, results files from the wrong date,
   text that no longer matches the numbers it describes.
7. **External plausibility.** Is the size of the effect consistent with
   prior evidence, biology and the other estimates in the same data? An
   effect larger than in randomised trials, or in a group where it should
   be smaller, needs an explanation.

## 3. Output

- **Verdict**: does the claim survive? Choose one: survives, survives
  with a narrower claim (state it), or does not survive (state why).
- **Attacks that succeeded**, most damaging first: the attack, the evidence,
  how far it moves the estimate, and what claim remains defensible.
- **Attacks that failed**, briefly, with the evidence that defeated each:
  these belong in the report as robustness.
- **Attacks that could not be tested**, with the data or analysis that
  would test them.
- **The narrowest claim that survives every attack**, worded as it should
  appear in the report.

Write plainly, without hedging the findings of the attack and without
rhetoric. Separate what was verified (run or read) from what is argued.
Offer to save the result (e.g. `notes/red_team_<topic>_<date>.md`); do not
share it without being asked.

## 4. After the red team

With the user, turn each successful attack into a change: a new analysis, a
narrower claim, a limitation stated with its direction, or a data request.
Turn each failed attack into a sensitivity analysis or a sentence in the
report. Rerun and check the changed claims against their numbers.
