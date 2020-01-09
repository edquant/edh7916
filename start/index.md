---
layout: default
title: Getting started
date: 2020-01-08 00:00:00
---

You'll need to download and install a few programs on your computer
for this course. You'll also need to register for a GitHub
account. All software and registrations are free.

## Software links

Unless you have experience building from source, select the binary
download that matches your operating system (_e.g._, Windows, MacOS, or
Linux). Some links take you to the same page. In that case, make sure
you select the correct version for your operating system.

Unless you have a particular reason against doing so, I recommend
installing everything using the default options presented during the
installation processes.

||MacOS|Windows|Linux|  
|:-|:--|:------|:----|  
|R|[Link](https://cran.r-project.org/bin/macosx/)|[Link](https://cran.r-project.org/bin/windows/base/)|[Link](https://cran.r-project.org/bin/linux/)|  
|RStudio|[Link](https://www.rstudio.com/products/rstudio/download/#download)|[Link](https://www.rstudio.com/products/rstudio/download/#download)|[Link](https://www.rstudio.com/products/rstudio/download/#download)|  
|Git|[Link](https://git-scm.com/downloads)|[Link](https://git-scm.com/downloads)|[Link](https://git-scm.com/downloads)|  

See the issues section below for common setup problems.

## GitHub registration

If you don't already have one, you'll also need to sign up for a [free
GitHub account](https://github.com/join) if they haven’t already. You
should sign up using your University of Florida email address and
request an [education
discount](https://education.github.com/benefits). Both processes are
easy, and the second gives you access to free private repositories.

## Optional

Throughout the class, we'll use RStudio to interact with
git/GitHub. But there are many ways to use git / GitHub, some of which
you may like better. On one extreme, you can interact with git using
the terminal prompt (Windows users need a slightly modified setup):

```bash
# pull from remote
$ git pull

# add/commit/push changes to remote
$ git add .
$ git commit -m "fixing coding error in clean_data.r"
$ git push -u origin master
```

There are many other GUI (point and click) applications that you can
use as well. Here are a couple you might try:

- [GitHub Desktop](https://desktop.github.com)  
- [Sourcetree](https://www.sourcetreeapp.com)  

## Issues
### Windows

Some students get errors when first using git with RStudio relating to
`user.email` and `user.name`. If you get this error, do the following
in RStudio.

1. In the **Terminal** (not the **Console** but the tab next to it ---
   the prompt should have a `$` and not `>`), type
   ```bash
   $ git config --list --show-origin
   ```
   If you see nothing related to your GitHub user ID or email or the
   information is incorrect, continue to the next step.
2. One at a time, type
   ```bash
   $ git config --global user.name "JohnDoe"
   $ git config --global user.email "johndoe@example.com"
   ```
   replacing your GitHub ID and email within the quotes
3. Type
   ```bash
   $ git config --list --show-origin
   ```
   again to confirm that information is now stored (it should print to
   the Terminal output).
4. Use Git to confirm it has worked.
