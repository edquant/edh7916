---
layout: lesson
title: Assignment 1
subtitle: EDH7916
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

In this first assignment, I'm asking you to do five things:

1. Make sure you've got your computer set up for class with all
   required software loaded and working.
1. Set up your GitHub user profile / README
1. Practice working with RStudio.
1. Practice working with Markdown syntax.
1. Practice with git by uploading your work through GitHub.

## Software installation

If you weren't able to get everything set up and working prior to or
during our first class meeting, please take time to finish installing
all the software required for the course. Please set up a time to meet
with me ASAP if you are having issues.

## Complete your GitHub profile

If you haven't already, please do the following things for your GitHub
profile:

1. Add a picture (I don't care whether you use a photo of yourself or
   something else more private, but please use something other than
   the default icon).
1. [Create a profile README using these
   instructions](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-profile/customizing-your-profile/managing-your-profile-readme). It
   doesn't have to be fancy and can include minimal information that
   you are comfortable publicly sharing, but at the very least please
   have something. You can use the default prompts or create your own.
   
## Practice creating an R (`*.R`) script

1. Open RStudio
1. Initialize a _New File_ > _R Script_ in RStudio. Save it as
   `<lastname>_assignment_1.R` in the `assignments` folder in your
   personal repo, replacing `<lastname>` with your last name. For
   example, I would call my assignment `skinner_assignment_1.R` and it
   would be located in the following location:
   ```
   student_skinner/
   |
   |__assignments/
       |
	   |__skinner_assignment_1.R
   
   ```
   **NOTE** that you can complete these steps using either the drop
   down menus or the icons.
   
   Also, don't forget to add `.R` to the end of your file. You will
   know you've done it correctly if the tab with your file name
   changes to include an icon that looks like a sheet of paper with an
   "R" superimposed on it.
1. Copy the following code snippet into your file and save the file:
   ```r
   ## install rmarkdown package
   install.packages("rmarkdown")
   ```
1. Run the code to install the RMarkdown package either by
   1. Highlighting the code and pushing the _Run_ button
   1. Putting your cursor on the line of code and using the key combo
      of Command-Enter (Mac) or Control-Enter (Windows) to run  

## Practice creating a Markdown (`*.md`) file

**NB:** Use _The Markdown Guide_ at
[www.markdownguide.org](https://www.markdownguide.org/getting-started)
to help you with this portion of the assignment.

1. Open RStudio
1. Initialize a _New File_ > _Text File_ in RStudio. Save it as
   `<lastname>_assignment_1.md` in the `assignments` folder in your
   personal repo, replacing `<lastname>` with your last name (note the
   different file ending this time). For
   example, I would call my assignment `skinner_assignment_1.md` and it
   would be located in the following location:
    ```
   student_skinner/
   |
   |__assignments/
       |
	   |__skinner_assignment_1.md
   
   ```
   Don't forget to add `.md` to the end of your file. You will know
   you've done it correctly if the tab with your file name changes to
   include an icon that looks like a sheet of paper with an "MD"
   superimposed on it. 
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
   `*.html`). You should stage, commit, and push these files in
   addition to the working `*.md` file.
1. As you’re working, take the following steps to add/stage, commit,
   and push your work to your repo using the Git tab in the upper
   right frame: 
   1. **Add/Stage** your changes to your file by clicking the button
      next to the file.
   1. **Commit** your changes with a short but informative message.
   1. **Push** your commit to GitHub.
   1. Log into the GitHub website, navigate to your repo, and confirm
      that you can see your changes. 

Remember, you can do these steps as many times as you want. I would
encourage you to commit smaller changes and push to your remote GitHub
repo often rather than wait until the last minute.

#### Submission details

- All aspects of the assignment need to be completed by the start of
  the next class. That means everything pushed to your remote GitHub
  repo before class starts. Your profile should be updated by the
  start of class as well.
- You may work together and borrow code, but everyone must submit
  their own files. Also, if you directly borrow code, please attribute
  that help in some way in your files (_e.g._, a commented line in the
  `.R` script).
