---
layout: lesson
title: Initial analyses
subtitle: "EDH7916 | Summer (C) 2020"
author: Benjamin Skinner
order: 2
category: finalproject
links:
  pdf: fp_initial_analyses.pdf
output:
  md_document:
    variant: gfm
    preserve_yaml: true
---

From the syllabus:

> For your final project, you must produce a 3-5 page report on a higher
> education topic of interest. The report should be a combination of
> writing, tables, and figures, have minimal citations (if any), and be
> fully reproducible with minimal effort. You must use data that is
> either publicly available or that can be shared with others (no IRB
> restrictions). Everyone will submit three preliminary assignments in

addition to the final report.

**This assignment represents the second of those three preliminary
assignments.**

For your initial analyses, I need the following in either a cleanly
formatted R (`.R`) script or RMarkdown (`.Rmd`) file:

1.  Code that:
      - Reads in the data set that contains your dependent variable
      - **\[If appropriate\]** Converts missing values to NA
      - **\[If appropriate\]** Reshapes data
      - **\[If appropriate\]** Joins data
2.  **3** of the **4** following plots:
      - A univariate graphic describing the dependent variable (*e.g.*
        histogram)
      - The conditional mean of your dependent variable at levels of at
        least one independent variable (*e.g.* box-and-whisker)
      - The distribution of your dependent variable at levels of at
        least one independent variable (*e.g.* grouped density plot,
        faceted density plot)
      - A bivariate graphic that compares your dependent variable with
        at least one other independent variable (*e.g.* scatter plot)

#### Submission details

  - Upload to our CANVAS course site no later than 11:59 p.m. EDT on the
    due date
  - Save your file as:
      - `<name>_analyses.R` (if submitting an R script)
      - `<name>_analyses.Rmd` (if submitting an Rmd file)
    where your last name replaces `<name>` (*e.g.* `skinner_analyses.R`
    or `skinner_analyses.Rmd`)
