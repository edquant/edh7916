---
layout: lesson
title: "Assignment: Introduction to mapping in R"
subtitle: EDH7916
author: Benjamin Skinner
order: 5
category: extra
links:
  pdf: assignment_mapping.pdf
output:
  md_document:
    variant: gfm
    preserve_yaml: true
---

Using data from the `geo` directory in the data folder, please answer
the following question. Use comments to respond as necessary.

## Questions

1. Re-project and re-plot your lower 48 states map `df_l48` using a
CRS code of 3338 (good for Alaska) and 32136 (good for
Tennessee). What happens to the map each time?
1. Choose a different cut point for BA attainment and different
years. Plot another small multiples plots showing changes over time.
1. Rerun this bit of code, 
   ```r
   df_sch_zip %>%
      st_drop_geometry() %>%
  	  group_by(zip) %>%
	  summarise(num_schools = n()) %>%
	  arrange(desc(num_schools))
   ```
   but store the results in a tibble this time. Join the tibble back
   to the `df_zip` sf object and make a plot that color codes each zip
   code by the number of schools it contains. 
1. Using the Alchua County geo data, flip the order of `df_zon` and
`df_zip` in `st_intersection()` in order to see how many school zones
are in each zip code. Choose a zip code that covers more than one
elementary zone and plot it, color coding the unique elementary school
zones.

#### Submission details

- Save your script (`<lastname>_assignment_mapping.R`) in your `scripts`
  directory.
- Push changes to your repo (the new script and new folder) to GitHub
  prior to the next class session.





