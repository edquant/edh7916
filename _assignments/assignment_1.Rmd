---
layout: lesson
title: Assignment 1
subtitle: "EDH7916 | Summer (C) 2020"
author: Benjamin Skinner
order: 1
category: problemset
links:
  pdf: assignment_1.pdf
output:
  md_document:
    variant: gfm
    preserve_yaml: true
---

In this first assignment, I'm asking you to do three things:

1. Make sure you've got your computer set up for class with all
   required software loaded and working.  
1. Practice working with RStudio.  
1. Practice working with Markdown syntax.  

## Software installation

Install all the software required for the course. Please set up a time
to meet with me ASAP if you are having issues.
   
## Practice with RStudio

1. Open RStudio
1. Initialize a _New File_ > _R Script_ in RStudio. Save it as
   `<lastname>_assignment_1.R`, replacing `<lastname>`
   with your last name. (You can complete these steps using either the
   drop down menus or the icons.) 
   
   Don't forget to add `.R` to the end of your file. You will know
   you've done it correctly if the tab with your file name changes to
   include an icon that looks like a sheet of paper with an "R"
   superimposed on it. Also, don't forget where you saved it on your
   computer (you'll need to be able to find it so that you can upload
   it to CANVAS).
1. Copy the following code snippet into your file and save the file:
   ```r
   ## install rmarkdown package
   install.packages("rmarkdown")
   
   ## install tinytex
   install.packages("tinytex")
   tinytex::install_tinytex()
   ```
1. Run the code to install the RMarkdown package either by
   1. Highlighting the code and pushing the _Run_ button
   1. Putting your cursor on the line of code and using the key combo
      of Command-Enter (Mac) or Control-Enter (Windows) to run  

## Practice with Markdown syntax

**NB:** Use _The Markdown Guide_ at
[www.markdownguide.org](https://www.markdownguide.org/getting-started)
to help you with this portion of the assignment.

1. Open RStudio
1. Initialize a _New File_ > _Text File_ in RStudio. Save it as
   `<lastname>_assignment_1.md`, replacing `<lastname>`
   with your last name. (You can complete these steps using either the
   drop down menus or the icons.) 
   
   Don't forget to add `.md` to the end of your file. You will know
   you've done it correctly if the tab with your file name changes to
   include an icon that looks like a sheet of paper with an "MD"
   superimposed on it. Also, don't forget where you saved it on your
   computer (you'll need to be able to find it so that you can upload
   it to CANVAS).
1. Within your file, please include the following:
   1. A top-level (h1) header with the assignment name: "Assignment 1"
   1. The following sentence, but add markdown syntax so that one word
     is **bolded**, one is _italicized_, and one is *__bold italicized__*:  
	 
		```
		In God we trust. All others must bring data.
		```
   1. An unordered list of 3-5 book titles (italicized) with author
   1. A block quote of one of your favorite short quotes (don't forget
      to include attribution)
   1. A code block with the code `x <- 1` inside
1. Check that your file builds correctly using RStudio's _Preview_
   button. You'll see that a `*.pdf` or an `*.html` version of the
   file will be saved in same place as your `*.md` file. Whether it is
   a PDF or HTML file will depend on whether you selected to _Preview
   HTML_ or _Preview PDF_ if you clicked the down arrow instead of the
   button directly (the default if you click the button should be
   `*.html`).

#### Submission details

- Upload both files (`<lastname>_assignment_1.R` and
  `<lastname>_assignment_1.md`) to our CANVAS course site no later
  than 11:59 p.m. EDT on the due date.
