---
name: academic-writing-standards
description: Expert knowledge of academic writing standards for peer-reviewed papers, including citation integrity, style compliance, clarity, and scientific writing best practices. Use when reviewing or editing academic manuscripts, papers, or research documentation.
---

# Academic Writing Standards

This skill provides expertise in academic writing standards for peer-reviewed research papers, ensuring clarity, rigour, and adherence to scientific writing conventions.

## Core Writing Principles

### Clarity and Directness

**Prioritise:**

- Clarity over eloquence
- Precision over persuasion
- Plain language with natural, varied sentence structure
- Connected prose that makes the relationship between ideas explicit
- Active voice wherever possible

**Avoid:**

- Unnecessary adjectives and adverbs
- Overstatement and hyperbole
- Excessive qualification ("very", "clearly", "significantly", "novel")
- Complex punctuation where simpler alternatives work
- A sequence of short declarative sentences when a well-structured sentence
   would read more naturally

**Sentence rhythm:**

- Do not equate clarity with brevity. Vary sentence length and use transitions
   to connect cause, contrast, and consequence.
- Prefer one complete sentence for closely related ideas. Split a sentence only
   when it contains genuinely independent claims or nested clauses that obscure
   the meaning.
- In scientific and technical prose, state the main claim, then attach the
   evidence, condition, or implication in the same sentence where this improves
   flow and does not reduce precision.

### Style Transformations

**Examples of preferred style:**

```
Wordy: "The results clearly demonstrate that the novel approach significantly outperforms existing methods"
Better: "The approach outperforms existing methods"

Complex: "The model—which incorporates multiple data sources; including case counts, hospitalisations, and genomic data—provides insights"
Better: "The model incorporates case counts, hospitalisations, and genomic data to provide epidemiological insights."

Passive: "It was found that the infection rate was increasing"
Active: "We found the infection rate increased"

Hedged: "It appears that the results seem to suggest that there might be a relationship"
Direct: "The results suggest a relationship"
```

### Punctuation Simplification

**Avoid semicolons** when possible:
```
Avoid: "The model includes three components; case counts, delays, and reporting rates"
Better: "The model includes three components: case counts, delays, and reporting rates"
```

**Avoid excessive em-dashes:**
```
Avoid: "The approach—which we developed over three years—shows promise"
Better: "The approach, developed over three years, shows promise."
```

**Simplify nested clauses:**
```
Avoid: "The method, which incorporates data from multiple sources, including surveillance systems, which track cases daily, and laboratory reports, provides estimates"
Better: "The method combines daily surveillance data with laboratory reports to produce estimates."
```

### Cross-references to Tables and Figures

**Never use positional references** ("above", "below", "the following table",
"as shown below"). Always cross-reference a specific numbered table or figure.

```
Avoid: "The results reported below describe field-level agreement."
Better: "Field-level agreement is reported in @tbl-variable-f1."
```

**State the result first, cite the table or figure in parentheses.** Do not
use "Table X shows" or "Figure Y illustrates" as sentence subjects. The
figure/table is not the actor; the finding is.

```
Avoid: "Table 2 shows that GPT-5 achieved 90% recall."
Better: "GPT-5 achieved 90% recall (@tbl-case-performance)."

Avoid: "Figure 3 illustrates the relationship between link count and F1."
Better: "Relationship F1 varied across link-count groups (@fig-complexity)."
```

**Do not describe what a table or figure contains.** Meta-commentary such as
"This section collects results that summarise the main tables" or "The figure
condenses the data into a single view" tells the reader about the document
rather than about the science. State the finding and cite the reference.

```
Avoid: "Figure 1 condenses field-level agreement into a single view."
Better: "Core-field F1 ranged from 80% to 100% across models (@fig-performance-summary)."
```

## Evidence-Led Scientific Narrative

### Build the Argument in Stages

Organise the paper around the inferential problem rather than the order in
which analyses were performed. A strong progression is:

1. Establish the phenomenon that requires explanation.
2. Test and, where possible, exclude plausible artefactual explanations.
3. Quantify the main effect using complementary analyses.
4. Compare competing mechanisms or explanations.
5. Evaluate consequences under explicit assumptions or scenarios.
6. State limitations and finish with the conclusion that remains supported.

Each section should answer a distinct question and create the reason for the
next section. Use descriptive headings that name the scientific task or
finding rather than generic labels when journal format permits.

### Triangulate Across Analyses

When several datasets or models address the same estimand, present them as
complementary lines of evidence rather than as interchangeable repetitions.
For each analysis, state:

- the data source and population;
- the estimand or hypothesis;
- the assumptions that distinguish the analysis;
- the estimate and its uncertainty; and
- whether the result agrees with the other analyses.

Agreement across methods with different biases strengthens an inference.
Differences should be attributed to assumptions, data, or model structure
rather than averaged away without justification.

```
Weak: "Several models produced similar results."
Better: "Estimates were consistent across sequence-based and diagnostic-proxy
analyses despite their different sampling and measurement assumptions."
```

### Separate Observation, Inference, and Consequence

Make clear whether a statement reports observed data, a model-based estimate,
a mechanistic interpretation, or a projected consequence. Do not write model
outputs as direct observations or scenarios as forecasts unless the analysis
was designed and validated for prediction.

```
Observation: "The lineage frequency increased in all sampled regions."
Estimate: "The model estimated a 43% increase in the reproduction number."
Interpretation: "Higher infectiousness was the most parsimonious explanation."
Projection: "Under the stated vaccination scenario, admissions were projected
to exceed the previous peak."
```

Use causal language only when the design supports causal identification.
Otherwise use calibrated terms such as "associated with", "consistent with",
"supports", or "could be explained by".

### Calibrate Claims to Evidence

State the strongest conclusion supported by the analysis, then identify the
assumption or uncertainty that bounds it. Prefer explicit contrasts over vague
hedging.

```
Weak: "Severity may possibly have changed."
Better: "The estimate was compatible with moderate decreases or increases in
severity, so the data did not identify a clear change."
```

Distinguish among:

- absence of evidence and evidence of absence;
- best-supported and proven explanations;
- model fit and biological confirmation;
- robustness to tested assumptions and robustness in general; and
- statistical uncertainty and structural uncertainty.

When mechanisms are not mutually exclusive, say so. A best-fitting model can
identify the most parsimonious explanation without establishing that it acts
alone.

## Section-Level Guidance

### Abstracts

Write the abstract as a compact argument:

1. Define the problem and why it matters.
2. Name the analytical approach and key data sources.
3. Report the principal estimate with its uncertainty.
4. State the main interpretation at the level supported by the evidence.
5. Give the practical implication, preserving conditions and time horizon.

Include numerical results rather than qualitative claims such as "performed
well". Distinguish estimates from projections and avoid introducing methods,
outcomes, or policy claims not developed in the paper.

For structured abstracts, use the journal's required headings. A useful
scientific sequence is Introduction, Rationale, Results, and Conclusion.

### Introduction and Rationale

Move from context to the unresolved problem, then state why resolving it
matters and what the study does. End with the study questions or analytical
strategy. Avoid a broad literature catalogue when a small number of findings
is sufficient to establish the gap.

### Results

Lead each subsection with the finding, then provide the estimate, uncertainty,
comparison, and robustness evidence. Keep interpretation close enough to make
the inferential logic clear, but reserve broader meaning and recommendations
for the Discussion.

When comparing hypotheses, define them before reporting model selection or
fit. Report both the preferred explanation and credible alternatives. Explain
why poorly supported explanations fail, using observable implications where
possible.

### Methods

Methods should enable an informed reader to reconstruct what was analysed and
how each claim was obtained. For every major analysis, report:

- data provenance, dates, geography, population, and exclusions;
- outcome, exposure, covariates, and unit of analysis;
- model structure and the role of key parameters;
- assumptions linking fitted quantities to reported estimands;
- uncertainty method, model comparison criteria, and sensitivity analyses;
- software, package versions, code, and data availability where relevant; and
- departures from the preregistered or planned analysis, if applicable.

Define a quantity before interpreting it. When transforming an estimate, give
the equation or reasoning and state the assumptions required for that
transformation. Report how dependence, clustering, repeated observations,
measurement error, and misclassification were handled.

### Scenarios and Projections

Label scenario analyses explicitly and list their assumptions, intervention
timing, parameter values, and time horizon. Use "projected" for conditional
model outputs and reserve "predicted" or "forecast" for genuine out-of-sample
prediction. State that a scenario is indicative rather than predictive when
appropriate.

Separate effects on peak burden, cumulative burden, and timing. A measure can
have little effect on an imminent peak yet substantially reduce later burden.

### Discussion and Limitations

Begin by answering the study question with the principal estimate and its
uncertainty. Relate the result to convergent and conflicting evidence, then
explain implications.

Limitations should map directly to claims. For each important limitation,
state:

1. what the analysis omitted, assumed, or measured imperfectly;
2. which estimate or interpretation it may affect;
3. the likely direction of bias, when defensible; and
4. which sensitivity analysis or future evidence could resolve it.

Do not use a generic limitations inventory. Revisit the conclusion after the
limitations and state what remains supported, rather than merely repeating the
abstract.

## Reporting Quantitative Evidence

- Pair point estimates with interval estimates and identify the interval type.
- Give denominators, time windows, and comparison groups where needed.
- Report ranges across models as ranges across models, not as one confidence or
   credible interval.
- Use confidence intervals for frequentist estimates and credible intervals
   for Bayesian posterior estimates.
- State the scale of relative effects, such as odds, risk, rate, growth rate,
   or reproduction number, and provide absolute effects when decision-relevant.
- Define whether percentages are percentage-point differences or relative
   percentage changes.
- Keep numerical precision commensurate with measurement and model uncertainty.
- Report sensitivity analyses by naming the changed assumption and stating
   whether the substantive conclusion changed.

## Reproducibility and Transparency

End the paper with clear statements on data availability, code availability,
funding, author contributions, and competing interests. Link to persistent,
versioned archives when possible. Distinguish openly available data from data
that require permission, and identify any third-party restrictions.

Treat peer commentary and post-publication responses as distinct from the
article's evidence. They may identify assumptions worth discussing, but they
do not silently override the peer-reviewed analysis.

### Exemplar and Scope

The evidence-led narrative guidance above is informed by Davies et al.,
"Estimated transmissibility and impact of SARS-CoV-2 lineage B.1.1.7 in
England" (*Science*, 2021; doi:10.1126/science.abg3055). The article is an
exemplar of triangulation, explicit scenario assumptions, comparison of
mechanistic hypotheses, and claim-linked limitations. Adapt these rhetorical
patterns to the study design and target journal. Do not copy distinctive
phrasing or treat the article's topic-specific methods as universal standards.

## Formatting Standards

### Document Structure

- **One sentence per line** in markdown format
- **Maximum 80 characters per line**
- **UK English** spelling (favour, colour, modelling, analyse)
- No trailing whitespace
- No spurious blank lines

### Mathematical Notation

- Use proper LaTeX formatting in appropriate contexts
- Define all notation clearly on first use
- Keep mathematical exposition accessible

## Citation and Reference Standards

### Citation Format Checking

**Common formats to verify:**
- Pandoc markdown: `[@author2024]`, `[@author2024; @other2023]`
- Multiple citations: `[@first2024; @second2024]`
- In-text citations: `@author2024 showed that...`

### Reference Integrity

**Check for:**
- Placeholder citations: `[@placeholder]`, `[@TODO]`, `[@CITE]`
- Malformed citations: Missing brackets, typos in citation keys
- Dangling references: Citations in text without corresponding bibliography entries
- Unused references: Bibliography entries never cited

**Citation consistency:**
- Verify citation keys follow consistent naming (e.g., `authorYear`, `author_year`)
- Check citation formatting matches throughout document
- Ensure proper use of et al. in multi-author citations

### Bibliography Verification

**When .bib file available:**
- Cross-reference every citation against bibliography
- Check for missing entries
- Verify citation keys match exactly
- Note any formatting inconsistencies in bibliography

**When .bib file unavailable:**
- Flag that references cannot be fully verified
- Suggest author independently verify all citations
- Check citation formatting consistency in text

## Originality and Attribution

### Identifying Potential Issues

**Flag text that:**
- Uses distinctive phrasing that may be borrowed
- Contains technical descriptions matching common sources
- Includes sequences of concepts in specific order suggesting copying
- Lacks clear paraphrasing when discussing others' work

**Not plagiarism checking:**
- Cannot definitively identify plagiarism
- Flags passages requiring author verification
- Suggests paraphrasing where appropriate
- Encourages proper attribution

### Proper Paraphrasing Guidance

**Poor paraphrasing:**
```
Original: "The model incorporates a hierarchical Bayesian structure with conjugate priors"
Poor: "The approach uses a hierarchical Bayesian framework with conjugate priors"
```

**Good paraphrasing:**
```
Better: "We used Bayesian hierarchical modelling with conjugate prior distributions"
```

## AI-Generated Writing Tells

When writing or reviewing prose, actively scan for and remove patterns
that signal AI-generated text. These undermine credibility with editors
and reviewers.

### Paragraph Structure

Do not open every paragraph with a short, punchy declarative sentence
followed by elaboration. This "topic sentence + expansion" template,
repeated across paragraphs, is one of the most recognisable AI tells.

**Vary paragraph openings:**

- Mix sentence lengths: some paragraphs should open with a longer,
  compound sentence that sets context and claim together.
- Use conditional or temporal clauses to enter a paragraph ("When a
  highly cited paper contains...", "In April 2026, Anthropic
  announced...") rather than always leading with a declaration.
- Fold the topic claim into the body of the paragraph rather than
  isolating it as a standalone opener.

```
AI pattern (every paragraph):
  "This is important. [elaboration]"
  "The tools already exist. [elaboration]"
  "The consequences compound. [elaboration]"

Better: vary the entry point, length, and grammatical structure of each
opening so no two consecutive paragraphs begin the same way.
```

### Rhetorical Patterns to Remove

- **Tricolon lists** as a rhetorical flourish: "reading code, tracing
  data flow, and reasoning about logical correctness" used for emphasis
  rather than precision. If the list is informative, keep it; if it is
  rhythmic, cut or restructure it.
- **Anaphoric repetition**: "sometimes X, sometimes Y" or "not just X,
  but Y". Use plain connectives instead.
- **Self-referential meta-commentary**: "a finding that is itself a
  measure of..." Let the evidence speak without narrating its
  significance.
- **Dramatic one-sentence paragraph openers**: "The consequences
  compound." These read as editorial rather than analytical.
- **Tidy wrap-up sentences**: "The resulting scientific record will be
  more reliable." Prefer conditional or qualified closings that reflect
  the actual state of evidence.
- **Telling the reader how to feel**: "We should be worried" or
  "What they find is unlikely to be reassuring." State consequences
  and let the reader draw their own conclusion.

### Register Consistency

- **Measured over dramatic.** Prefer "may need re-examination" over
  "becomes suspect"; "is instructive" over "illustrates the scale of
  potential harm"; "could, in principle, have identified" over "could
  have flagged in minutes."
- **Conditional over declarative** for forward-looking claims. Use "if
  these tools are adopted widely" rather than asserting outcomes as
  certain.
- **Cut filler adverbs**: "directly", "just", "simply", "merely" rarely
  add meaning. Remove unless they disambiguate.
- **Avoid formulaic metaphors**: "a tangle of", "a flood of", "a
  landscape of". Use plain description.

## Common Writing Issues

### Overused Qualifiers

**Remove or replace:**
- "clearly", "obviously", "evidently" → Often unnecessary, let evidence speak
- "very", "quite", "rather" → Use stronger base word
- "significantly" → Reserve for statistical significance
- "novel", "new" → Show novelty through comparison, don't claim it
- "state-of-the-art" → Demonstrate through benchmarking

### Vague Language

**Replace with specifics:**
```
Vague: "The model performed well"
Specific: "The model achieved 95% accuracy"

Vague: "We used a large dataset"
Specific: "We used a dataset of 10,000 cases"

Vague: "Results improved substantially"
Specific: "Accuracy improved from 80% to 92%"
```

### Redundancy

**Common redundancies to fix:**
- "past history" → "history"
- "future plans" → "plans"
- "end result" → "result"
- "basic fundamentals" → "fundamentals"
- "completely finished" → "finished"

## Field-Specific Conventions

### Epidemiology and Public Health

- Use "infection" not "case" when referring to true infections
- Distinguish "reported cases" from "infections"
- Use "reproduction number" not "R value" in formal writing
- Define abbreviations on first use: "reproduction number (R)"

### Statistical Reporting

- Report confidence/credible intervals: "estimate (95% CI: lower, upper)"
- Use "uncertainty interval" for Bayesian analyses
- Report p-values accurately: "p < 0.001" not "p = 0.000"
- Distinguish statistical significance from practical importance

### Computational Methods

- Use "implementation" not "coding"
- "Algorithm" for theoretical description, "implementation" for code
- Report computational resources when relevant
- Specify software versions and packages

## Review Structure

When reviewing academic writing, structure feedback as:

1. **Reference Issues**
   - Citation formatting problems
   - Placeholder citations
   - Missing bibliography entries
   - Inconsistencies in citation style

2. **Attribution Concerns**
   - Passages requiring verification
   - Suggestions for better paraphrasing
   - Unclear sourcing of ideas

3. **Style Improvements**
   - Clarity and conciseness suggestions
   - Active voice conversions
   - Simplified sentence structures
   - Removed unnecessary qualifiers

4. **Formatting Issues**
   - Line length violations
   - Formatting inconsistencies
   - Spelling (UK vs US English)

## When to Apply This Skill

Use these standards when:
- Reviewing academic manuscripts
- Editing research papers
- Preparing submissions to journals
- Writing methods sections
- Drafting discussion sections
- Revising based on reviewer comments

Maintain scientific rigour whilst improving readability.
Always provide specific, actionable feedback with examples.
