# NSF DMS Quarto Starter

A modular Quarto/R starter project for developing an NSF Mathematical
and Physical Sciences / Statistics proposal.

## Requirements

- Quarto
- R
- A LaTeX distribution capable of producing PDF
- R packages:
  - ggplot2
  - dplyr
  - tidyr

Install packages with:

```r
install.packages(c("ggplot2", "dplyr", "tidyr"))
```

## Render

From the project directory:

```bash
quarto render grant.qmd
```

The PDF will be written to:

```text
output/grant.pdf
```

## Source word-count check

Run:

```r
source("R/check_grant.R")
```

The check is deliberately advisory. NSF's official page limits are based
on the rendered proposal and the rules in the solicitation/PAPPG in effect
at submission.

## Workflow

1. Replace all `[PLACEHOLDER]` text.
2. Add real references to `references.bib`.
3. Replace illustrative figures with actual analyses.
4. Keep computational code in `R/`.
5. Render frequently.
6. Check the final PDF manually for page count, figures, tables, citations,
   and required proposal sections.
7. Before submission, verify the current NSF solicitation and PAPPG.

## Important

This starter is a writing/reproducibility scaffold, not an official NSF
submission template. NSF's required formats and page limits can change.
Use the current solicitation and PAPPG for final compliance.


## Figures

This version intentionally contains **no fabricated or placeholder plots**. Use `R/figure_template.R` as a starting point for figures based on your actual data or methods.
