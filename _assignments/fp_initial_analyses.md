---
layout: lesson
title: Initial analyses
subtitle: "EDH7916"
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

1. Code that:
   - Reads in the data set that contains your dependent variable
   - **[If appropriate]** Converts missing values to NA 
   - **[If appropriate]** Reshapes data
   - **[If appropriate]** Joins data
1. **3** of the **4** following plots:
   - A univariate graphic describing the dependent variable (_e.g._
      histogram)
   - The conditional mean of your dependent variable at levels of at
     least one independent variable (_e.g._ box-and-whisker)
   - The distribution of your dependent variable at levels of at least
     one independent variable (_e.g._ grouped density plot, faceted
     density plot)
   - A bivariate graphic that compares your dependent variable with at
     least one other independent variable (_e.g._ scatter plot)

#### Submission details

- Save your file as: 
  - `<name>_analyses.R` (if submitting an R script)
  - `<name>_analyses.Rmd` (if submitting an Rmd file)
  
  where your last name replaces `<name>` (_e.g._ `skinner_analyses.R` or
  `skinner_analyses.Rmd`) in your `final_project` folder.
- Push to your GitHub repo prior to the start of the class in which it
  is due. If you are unsure whether you have successfully pushed your
  changes, check the online version of your repo at GitHub.com. If you
  can see your changes there, I can see them too.
