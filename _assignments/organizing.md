---
layout: lesson
title: Assignment 2
subtitle: "EDH7916 | Spring 2020"
author: Benjamin Skinner
order: 2
category: assignment
links:
  pdf: organizing_hw.pdf
output:
  md_document:
    variant: gfm
    preserve_yaml: true
---

***NOTE** This assignment needs to be completed by the start of the
second class. That means everything pushed to you remote GitHub repo
before class starts.*

## Steps

Using `template.R`:

1.  Rename it to `organizing_hw_<your_last_name>.R`.
2.  Fill in all relevant header information about the script.
3.  Load the **{tidyverse}** library
4.  Create objects/macros with the paths to the following directories:
      - data
      - figures
      - tables
5.  Include the `old_to_new_score_ratio` macro, but change it to a new
    value.
6.  Include the `old_to_new_score()` function from class as is (just cut
    and paste).
7.  Read in the updated data set, `test_scores_updated.RDS`, we made in
    class.
8.  Create a new column called `test_scores_new_2` that converts the
    original test scores to updated values using your new ratio.
9.  Save the updated data file in your `data` directory with a different
    name. You should now have three files: the original, the updated one
    we made in class, and the one you just made.
10. Push everything to your GitHub repo (keep in mind that your new data
    sets won’t show up on your GitHub repo — that’s okay: I should be
    able to run your script and make them myself).

*Remember, you can do these steps as many times as you want. I would
encourage you to commit smaller changes and push to your remote GitHub
repo often rather than wait until the last minute.*
