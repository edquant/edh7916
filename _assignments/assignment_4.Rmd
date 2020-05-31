---
layout: lesson
title: Assignment 4
subtitle: "EDH7916 | Summer C 2020"
author: Benjamin Skinner
order: 4
category: problemset
links:
  pdf: assignment_4.pdf
output:
  md_document:
    variant: gfm
    preserve_yaml: true
---

Using the `hsls_small.csv` data set and the online codebook, answer
the following questions. You **do not** need to save the final output
as a data file: just having the final result print to the console is
fine. For each question, I would like you to try to pipe all the
commands together. Throughout, you **should** account for missing values by
dropping them.

For each question, show your data work and, if necessary, answer the
question in a short (1-2 sentence(s)) comment.

## Questions

1. Compute the average test score by region and join back into the
   full data frame. Next, compute the difference between each
   student's test score and that of the region. Finally, return the
   mean of these differences by region.
1. Compute the average test score by region and family income
   level. Join back to the full data frame. **HINT** You can join on
   more than one key.
1. Select the following variables from the full data set:
   - `stu_id`
   - `x1stuedexpct`
   - `x1paredexpct`
   - `x4evratndclg`  
   
   From this reduced data frame, reshape the data frame so that it is
   long in educational expectations, meaning that each observation
   should have two rows, one for each educational expectation type.
   
   _e.g. (your column names and values may be different)_
   
   | stu_id | expect\_type | expectation | x4evratndclg |
   |:------:|:------------:|:-----------:|:------------:|
   | 0001   | x1stuedexpct | 6           | 1            |
   | 0001   | x1paredexpct | 7           | 1            |
   | 0002   | x1stuedexpct | 5           | 1            |
   | 0002   | x1paredexpct | 5           | 1            |

#### Submission details

- Upload your script (`<lastname>_assignment_4.R`) to our CANVAS
  course site no later than 11:59 p.m. EDT on the due date.
