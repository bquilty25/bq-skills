---
name: quarto-epi-deck
description: How to build an Epicentre (MSF) slide deck in Quarto that summarises an epidemiological analysis, the way the user wants every time - a PowerPoint deck in the Epicentre template that reads the same aggregate results as its report, one finding per slide with a title that states it, a few inline numbers, one figure sized for the slide, tables drawn as images, a take-home slide, and checks of the render. Use when creating a deck, adding or changing slides, or turning a report into a presentation. For reports use quarto-epi-report.
---

# Quarto slide decks (Epicentre)

A deck summarises an analysis for a team, consortium or external audience.
It reads the same aggregate results file as its report (quarto-epi-report)
and fits nothing. Every number on a slide is inline R
(quarto-dynamic-reporting). Project memory may add terminology, audience and
sharing rules; follow those too.

**Start every new deck from `templates/deck.qmd` in this skill's folder**:
copy it to `qmd/<topic>/<topic>_slides.qmd` and replace each `<...>`. It
holds the PowerPoint front matter with the Epicentre reference document, the
setup chunk with the slide theme and `slide_table()`, and the slide order
(data used, findings, limitations, take-home). When changing an existing
deck, follow that deck instead.

**The Epicentre PowerPoint template is in this skill's folder**:
`templates/epicentre_reference.pptx`, with the script that built it,
`templates/build_reference_pptx.py`. If the project has no copy, copy both
to `qmd/templates/`, so the deck's `reference-doc` points inside the project
and renders on any machine. Rebuild the reference document only from a
newer Epicentre deck, with the script's usage line.

## 1. Files and format

- **One `.qmd` per deck,** next to its report (for example
  `qmd/<topic>/<topic>_slides.qmd`), listed in the render list of
  `_quarto.yml` (documents in a subfolder find the Epicentre format only when
  listed) and in the project's registry of report dates, with every results
  prefix it reads.
- **Format:** PowerPoint in the Epicentre template, which colleagues can
  edit and present.

```yaml
format:
  pptx:
    # The Epicentre template, its layouts renamed for pandoc
    # (templates/build_reference_pptx.py)
    reference-doc: ../templates/epicentre_reference.pptx
    slide-level: 2
    monofont: Consolas
date: last-modified
date-format: "D MMMM YYYY"
execute:
  echo: false
  warning: false
  message: false
params:
  res_date: "latest"
  results_dir: "output/fits"
```

  Paths are relative to the deck. The reference document comes from this
  skill (see above) and is built from an Epicentre deck by its template
  script; do not edit it by hand.
  The HTML deck format of epitemplates (`epitemplates-deck`) exists, but
  shared decks are PowerPoint.
- **Title and subtitle** say what the deck covers; no commas in titles.

## 2. Setup chunk

As in the report: load packages, source the table and figure helpers, read
the results with `stopifnot()` checks on the file and its elements, and
define small helpers (`pct()`, `num()`, `one_row()`, one per quantity
cited). In addition:

- `knitr::opts_chunk$set(fig.showtext = TRUE)` and the template font
  (`slide_font <- epi_font()`), so that text in figures and tables renders
  in the Epicentre font even where the machine lacks it.
- A slide theme for ggplot: `theme_minimal(base_size = 14, base_family =
  slide_font)`, legend on top or right, no minor grid, bold strips.
- Tables as images, as pandoc's PowerPoint tables cannot be sized: a
  flextable in the template font, header in Epicentre blue `#2E569E`,
  horizontal rules only, drawn with `flextable::gen_grob()` and `plot()`
  inside a figure chunk.
- Assertions for any pattern a bullet states without its numbers.

## 3. Slides

- **One finding per slide.** The slide title states the finding ("MSF
  self-report agrees more closely with the registries than DHIS2
  self-report"), not the topic ("Agreement"). No commas in titles.
- **Three to five bullets,** each one line or two at most, with only the
  numbers the finding rests on: the headline estimate with its interval and,
  where it matters, one contrast. Bullets are fine on slides (unlike
  reports), in UK English, without em dashes.
- **One figure per slide,** below the bullets, sized for the slide area:
  `fig-width: 13` and `fig-height` from about 3.4 to 4.6 depending on the
  bullets above it. Base size 14; labels at the right of dot plots need
  their own margin (`coord_cartesian(clip = "off")` and wider x limits).
  Reuse the report's figure code, simplified: fewer panels, the key
  populations only. Keep the report's colours for each series.
- **Order:**
  1. Title.
  2. Data used: sources, dates, definitions the deck relies on.
  3. Findings, one per slide, in the order of the argument.
  4. Limitations or potential misclassification, with the direction of each
     bias, where they change how the findings read.
  5. Take-home: the conclusions in three to five bullets, then what is
     needed next.
- **Wording for the audience.** For a consortium or external audience, no
  internal file or script names, no people's names, neutral wording about
  other teams' data (describe how the data were collected, not that they
  are poor).

## 4. Checks before calling it done

1. Run the analysis script(s) the deck reads, then render the deck and
   confirm it exits cleanly.
2. Extract the slide text from the `.pptx` (it is a zip of XML; read the
   `<a:t>` elements of `ppt/slides/slide*.xml`) and search it for `NA`,
   `NaN`, `Inf`, `−0%` and empty parentheses.
3. Check every bullet against the numbers beside it, and every slide title
   against the figure below it.
4. Where the data are sensitive, do not open figures made from them: tell
   the user to check the layout (cut-off labels, crowded panels, slide
   overflow) and fix what they report.
5. Share (for example to a presentations folder) only when the user asks.
