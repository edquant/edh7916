---
layout: lesson
title: "Assignment: Inferential II"
subtitle: EDH7916
author: Benjamin Skinner
order: 1
category: extra
links:
  pdf: assignment_regression.pdf
output:
  md_document:
    variant: gfm
    preserve_yaml: true
---

Using `hsls_small`, please answer the following questions. Use
comments to respond as necessary.

## Questions

1. Using this multiple regression model from the lesson, 
   ```r
   lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc, data = df)
   ```
   add the fitted values to the residuals and store in an object,
   `x`. Compare these values to the math scores in the data frame.
1. Using this multiple regression model from the lesson,
   ```r
   lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc + factor(bystexp),
      data = df)
   ```
   Add the categorical variable `byincome` to the model above. Next
   use `model.matrix()` to check the RHS matrix.
1. Fit a linear model with both interactions and a polynomial
   term. Then look at the model matrix to see what R did under the
   hood. 
1. Fit a logit or probit model to another binary outcome than what was
   selected in the lesson (other than `plan_col_grad`: you can make a
   new one if you want).

#### Submission details

- Save your script (`<lastname>_assignment_regression.R`) in your `scripts`
  directory.
- Push changes to your repo (the new script and new folder) to GitHub
  prior to the next class session.





