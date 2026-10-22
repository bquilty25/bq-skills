---
name: diagram-design
description: Design language for hand-authored SVG schematics such as study-design diagrams, participant flow and eligibility funnels, follow-up timelines, and side-by-side method comparisons in epidemiology and analysis documents. Use when asked to draw, diagram or visualise a study design, analysis pipeline, cohort timeline, matching scheme or flow, for a report, Quarto document, analysis plan or slide. For data charts (plots, axes, palettes for series) use the bundled dataviz skill instead; this skill covers schematics with boxes, arrows, markers and annotations.
---

# Diagram design language

Hand-written SVG schematics that read as one family with the project's ggplot figures. The reference set is the Ervebo VE project (`docs/figures/` in that repo): `study_overview.svg`, `tnd_matching.svg`, `cohort_timeline.svg`, `tnd_eligibility_flow.svg`.

## Principles

1. **One idea per diagram, stated in the subtitle.** The title names the subject; the subtitle states the point or scope ("Both use the same exposure definition and the same prior").
2. **Real numbers, with their source and date.** Counts come from the actual data cut and are cited in the subtitle or footer ("MSF linelist, compilation of 26 September 2026").
3. **Encoding is constant across a project.** The same colour, shape and line style mean the same thing in every diagram and match the plot palette.
4. **Two attributes compose on one mark.** Use ring colour for role (case or control) and an inner dot for exposure (vaccinated). This avoids a combinatorial legend.
5. **Never rely on colour alone.** Excluded items are dashed and faded, events have distinct marker shapes, and everything important is also labelled in text.
6. **Label directly.** Put labels next to the thing. Use a legend only for marks that repeat, in a single white strip.
7. **End with the model.** Diagrams of an analysis close with a footer box stating the estimand or formula (VE = 1 − OR) and what is and is not adjusted.

## Canvas and type

- **Canvas.** `viewBox="0 0 900 H"` with matching `width`/`height`, and H fitted to the content (540–640 is typical). Draw a full background `rect` of `#fcfcfb`. Use 40 px side margins, so content spans x = 40 to 860.
- **Font.** `font-family="Helvetica, Arial, sans-serif"` on the root, with real `<text>` elements (never outlined paths).

| Role | Size | Weight | Colour | Position |
|---|---|---|---|---|
| Title | 19 | bold | `#0b0b0b` | x 40, y 34 |
| Subtitle (the point) | 13 | regular | `#52514e` | x 40, y 56 |
| Box or panel heading | 14 | bold | `#0b0b0b` | |
| Accent subheading | 13 | bold | accent colour | |
| Body text | 12 | regular | `#2b2b2a` | 16 px line spacing |
| Annotation | 11–12 | regular | `#52514e` | |
| De-emphasised note | 11–12 | regular | `#8a8984` | |

- **Line breaks.** Break lines by hand. Helvetica at 12 px averages about 6.2 px per character (14 px bold about 8 px), so a 500 px text column holds about 75 characters. Leave 16 px of padding inside boxes.
- **Text conventions.** Sentence case and UK spelling. Use an en dash for ranges (2–21 days), × for crossed strata (zone × FLW × month), and a true minus sign (−). No em dashes.

## Colour

### Neutrals

| Token | Hex | Use |
|---|---|---|
| background | `#fcfcfb` | canvas |
| panel | `#f1f0ec` | source boxes, example areas, shaded bands |
| divider | `#e4e3de` | legend and footer outlines, rules |
| stroke | `#8a8984` | neutral box outlines, dashed side arrows |
| ink | `#0b0b0b` | titles, headings |
| text | `#2b2b2a` | body |
| muted | `#52514e` | subtitles, annotations, arrows |
| faint | `#8a8984` / `#b9b8b3` | notes, dropped or excluded items |

### Semantic accents

Each accent is a stroke with a matching tint fill. They match the ggplot figure palette.

| Accent | Stroke | Tint | Meaning in the reference set |
|---|---|---|---|
| Blue | `#2a78d6` | `#e8f0fb` | proposed or harmonised method, exposure (vaccinated), eligible set, the TND panel |
| Orange | `#eb6834` | `#fde5d9` | cases, test-positive, the death-outcome study |
| Green | `#1baf7a` | `#dcefe7` | controls, test-negative, admission |

### Event markers (timelines only)

| Event | Colour | Shape |
|---|---|---|
| Onset | `#7b6fb3` | circle |
| Death | `#d6338a` | square |
| Transfer or censoring | `#f2b33d` | square |
| Discharge | `#7b6fb3` | square |

If a project's plots use another palette, swap the hexes but keep the roles.

## Marks

**Nodes**
- Rounded rectangles: `rx="6"` for nodes, `rx="8"` for panels.
- **Source and process nodes**: `#f1f0ec` fill with a `#8a8984` stroke.
- **Outcome nodes**: tint fill with the accent stroke.
- **Study or method panels**: white fill with a 1.5 px accent stroke. Heading at +26 px, accent subheading at +44 px, then body text.

**Arrows**
- Main flow: 1.5 px `#52514e` lines with a filled triangle marker:
  ```svg
  <marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="#52514e"/></marker>
  ```
- Side flows (exclusions): 1.2 px `#8a8984` with `stroke-dasharray="4 3"`.
- Arrows start and end on box edges.

**Individuals**
- Circles with `r="9"` and a 1.5 px ring in the role colour, tint fill.
- Exposure: an inner dot, `r="4"`, `#2a78d6`.
- Dropped or excluded: dashed `#b9b8b3` ring on `#f1f0ec`, with a faded inner dot (`#9ec0ea`).
- Pairing lines: 1.3 px `#52514e`.

**Timelines**
- **Time origin**: a vertical boundary with the origin event marker on it.
- **Model time pieces**: shaded background bands (blue tint for the band of interest, panel grey for the rest), labelled at the top in bold.
- **Rows**: one row per archetypal individual, labelled on the left with outcome and exposure ("Vaccinated, transferred").
- **Groups**: group the rows by exposure (vaccinated, then unvaccinated) under coloured group headings. Show every way follow-up can end in every group (event, discharge, transfer, still admitted at the data cut, truncation), so the viewer never wonders whether an outcome is possible for a group. One example per outcome spread across groups reads as if some combinations cannot happen.
- **Inner exposure dot on a filled marker**: give it a thin white ring (`stroke="#ffffff" stroke-width="1.2"`, `r="4"`) so it stays visible on the coloured fill.
- **Lines**: dashed grey for pre-origin time, a solid 3 px ink bar for time at risk, and an end marker with an inline label saying what it means ("discharged alive (censored)").
- **Outside the risk set**: show a row for people who never enter it (for example, death before admission), with the explanation in the accent colour.
- **Axis**: ticks every meaningful unit and a centred axis title that states any truncation.

**Legend and footer**
- **Legend**: a single white strip with a `#e4e3de` outline, 44 px high, with marks and labels in one row.
- **Footer or model box**: white with an accent stroke. A bold first line gives the model and estimand, followed by two or three body lines on adjustment and caveats.

## Layout patterns

1. **Fork into studies (overview).** A top-down chain of grey source nodes fans into tinted outcome nodes and then into side-by-side study panels. Close with a full-width strip for what the studies share (for example, the exposure definition).
2. **Current versus proposed (method comparison).** Two panels at x 40 and 470, each 390 wide, with identical example data so only the method differs. Each panel has a bold heading, a muted one-line scope, the example area, then a four-line paragraph on how it works and its cost. Below come a shared legend strip and a dated footnote with the real-data consequence ("1:1 matching kept 800 of 1,178").
3. **Follow-up timeline.** Row labels on the left (x 40–220), the pre-origin zone, then shaded model bands on a linear scale (20 px per day worked well for 28 days). Below sit the axis, legend strip and model box.
4. **Funnel with exclusions.** Main column at x 60–400 with counts in bold node text. Exclusions sit in a right-hand white card at x 470–860, with right-aligned counts (`text-anchor="end"`), group rules between steps and dashed arrows from the step they leave. Alternative definitions are small side-by-side boxes, with the current choice flagged in blue. A highlighted sub-flow card covers the subgroup that matters (for example, vaccinated cases).

## Content audit

Run this audit before calling a diagram finished; a diagram can be clean and still mislead.

1. **Every path ends somewhere.** Each person in the source population should be accounted for: excluded (and why), in one study, or in both. Typical gaps are untested people, invalid results, people treated outside the data source, and people never admitted.
2. **Each group has every outcome.** In timelines and outcome splits, show every outcome for every exposure group.
3. **Eligibility is stated per study.** When two studies share a source, state where their eligibility rules differ rather than implying they match.
4. **Marks don't imply analyses that aren't done.** For example, pair lines suggest a conditioned analysis. If the pairs are pooled into one regression, say so in the text.
5. **Shared rules sit in the shared strip.** A rule that applies to both studies (such as an exposure window) belongs in the shared strip, not in one study's panel.
6. **Derived numbers are marked.** Numbers worked out from reported ones (800 matched means 400 pairs, so about 93 cases dropped) carry "about" or show the arithmetic.
7. **Undocumented is said, not guessed.** Where the source does not say how something is handled, write "not documented" rather than inventing the rule.
8. **Dependence is flagged.** If one person can enter both analyses, the estimates are not independent; say so.
9. **Gaps against the plan are visible.** If the current practice omits a planned step, show it as a flagged note (accent colour) rather than leaving it out.

## Diagrams that show results

If a diagram carries numbers produced by an analysis (estimates, coverage, counts from a run), do not type them into the SVG. Keep a template with `{{key}}` placeholders (for example in `docs/figures/templates/`), and fill it from the output tables in the pipeline step that produces them. Have the filler stop if a placeholder lacks a value or a value lacks a placeholder. Hand-typed results go stale on the next run; the Ervebo repository's `diagram_functions.R` is a worked example.

## Workflow

1. Sketch the layout on the 900 px grid and decide which pattern applies.
2. Write the SVG by hand. Include a `<title>` element, and keep coordinates on round numbers.
3. Render and look at it before showing anyone:
   ```r
   rsvg::rsvg_png("docs/figures/x.svg", "/tmp/x.png", width = 1350)
   ```
   Then view the PNG.
4. Check for the failures that recur:
   - arrows crossing labels (start them from box edges away from the step label);
   - text overflowing boxes;
   - a label centred across the gap between two panels (give each panel its own);
   - a row label colliding with the first mark;
   - legend items running together.
5. Re-render after each fix.
6. Save to `docs/figures/` and embed:
   - Markdown: `![caption](figures/x.svg)`
   - Quarto: `![Caption sentence.](../docs/figures/x.svg){#fig-x}`

   `embed-resources: true` inlines it.
