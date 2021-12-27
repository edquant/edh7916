---
layout: lesson
title: Assignment 2
subtitle: "EDH7916 | Summer C 2020"
author: Benjamin Skinner
order: 2
category: problemset
links:
  pdf: assignment_2.pdf
output:
  md_document:
    variant: gfm
    preserve_yaml: true
---

1. Create a new top-level subdirectory in your course directory
   (_i.e._, the same level as `scripts`, `data`, and `figures`) called
   `tables`.
1. Take a screenshot of your RStudio application that shows this new
   folder in the **Files** facet and name it
   `<lastname>_assignment_2_screenshot.*` (where `*` is whatever file
   type your screenshot is in: `png`, `jpg`, _etc_).

Using `template.R` (and `organizing.R` for help), create a script that
does the following tasks --- be sure your script is well organized:

1. Rename it to `<lastname>_assignment_2.R` and put it in your
   `scripts` folder if its not already there.
1. Fill in all relevant header information about the script.
1. Load the **tidyverse** library
1. Create objects/macros with the paths to the following directories:
   - data
   - figures
   - tables
1. Include the `old_to_new_score_ratio` macro, but change it to a new
   value.
1. Include the `old_to_new_score()` function from class as is (just
   cut and paste).
1. Read in the data set, `test_scores.RDS`.
1. Create a new column called `test_scores_new_2` that converts the
   original test scores to updated values using your new ratio and the
   `old_to_new_score()` function.
1. Save the updated data file in your `data` directory with a
   new name. You should now have three files: the original, the
   updated one from the `organizing` lesson, and the one you just made.

**NOTE** When all is said and done, your new script should look much
like the `organizing.R` script, but with your changes.
  
#### Submission details

- Upload your script (`<lastname>_assignment_2.R`) and screenshot
  (`<lastname>_assignment_2_screenshot.*`) to our CANVAS course site
  no later than 11:59 p.m. EDT on the due date.
