---
layout: lesson
title: Assignment 3
subtitle: "EDH7916 | Summer (C) 2020"
author: Benjamin Skinner
order: 3
category: problemset
links:
  pdf: assignment_3.pdf
output:
  md_document:
    variant: gfm
    preserve_yaml: true
---

Using the `hsls_small.csv` data set and the online code book, answer
the following questions. You **do not** need to save the final output
as a data file: just having the final result print to the console is
fine. For each question, I would like you to try to pipe all the
commands together. You can account for missing values by dropping
them.

For each question, show your data work and then answer the question in
a short (1-2 sentence(s)) comment. 

## Questions

1. What is the average standardized math test score?
1. What is the average standardized math test score by gender?
1. In what year and month were the oldest students in the data set
   born? The youngest?
1. Among those students who are under 185% of the federal poverty line
   in the base year of the survey, what is the median household income
   (give the category and what that category reprents).
1. Of the students who earned a high school credential (diploma or
   GED), what percentage earned a GED or equivalency? How does this
   differ by region?
1. What percentage of students ever attended a postsecondary
   institution by February 2016? Give the cross tabulations for:  
     - family incomes less than or equal to $35,000 and greater than
       $35,000   
	 - region  
	 
   This means you should have percentages for 8 groups: above/below
   $35k within each region.   
   
   **HINT** You can `group_by()` on more than one group.
  
#### Submission details

- Upload your script (`<lastname>_assignment_3.R`) to our CANVAS
  course site no later than 11:59 p.m. EDT on the due date.

