---
layout: default
title: "Software installation"
category: page
links:
  pdf: installation.pdf
---

* Table of Contents
{:toc}

# Getting started

This course requires you to install a few bits of software on your
computer. Specifically, you need:

- R
- RStudio
- git
- LaTeX

These instructions should help you find and download what you
need. You do not need to use this guide, but it may help, particularly
if you aren't used to downloading and installing open source software.

I've done my best to include screenshots of each step or provide links
to external sites that already have excellent instructions (_e.g._,
git). One snag, however, is that while some in the class may use
Windows/PC, others use Apple/MacOS (I'm making the assumption that no
one is using Linux --- if you are, you probably don't need these
instructions!). I personally use MacOS. This means that some of the
screenshots are based on what I see as a Mac user on the software
websites. But where I can, I show sections for MacOS and Windows
downloads.

I also can't walk you through each step of the installation once
you've downloaded the correct files, again, because operating systems
differ. That said, he good news is that with only one exception (sorry
Windows users!), you should be able to install all software using the
default process like you do with most other software.

# Installing R

First things first, we'll get R, which you can find at
[https://cran.r-project.org](https://cran.r-project.org). Depending on
your operating system (OS), you'll click one of the following links at
the top of the home page.

![CRAN homepage]({{ site.baseurl }}/{{ site.img }}/cran_home.png)

## R for MacOS

When downloading R for MacOS, you'll want to click the link for the
latest version of R: `R-<#>.<#>.<#>.pkg` where `<#>.<#>.<#>` represent
the major, minor, and patch numbers. As of the writing of this
document (May 2020), the latest version of R is R 4.0.0 --- it may be
different (higher) when you download. Just grab the one inside the red
box.

You may be asked if you want to allow the download. If so, say yes and
pay attention to where you save it (typically your Downloads
folder). Once it has finished downloading, double click on the package
icon and follow the default directions to install.

![Page to download R for MacOS]({{ site.baseurl }}/{{ site.img }}/cran_mac_install.png)

## R for Windows

When downloading R for Windows, you'll first be taken to an
intermediate screen. Just click the indicated link to go to the next
page.

![Intermediate page to download R for Windows]({{ site.baseurl }}/{{ site.img }}/cran_windows_intermediate_screen.png)


On the next screen, click the link to "Download `R-<#>.<#>.<#>` for
Windows" where `<#>.<#>.<#>` represent the major, minor, and patch
numbers. As of the writing of this document (May 2020), the latest
version of R is R 4.0.0 --- it may be different (higher) when you
download. Just grab the one inside the red box.

You may be asked if you want to allow the download. If so, say yes and
pay attention to where you save it (typically your Downloads
folder). Once it has finished downloading, double click on the
installation icon and follow the default directions to install.

Depending on the level of control you have on your computer and how
you typically install software, you may want to install R as an
administrator. I would recommend that to head off issues down the
road, but if you don't have administrator privileges then go ahead an
install as a user.

![Page to download R for Windows]({{ site.baseurl }}/{{ site.img }}/cran_windows_install.png)

# Installing RStudio

Now that you've installed R, it's time to get RStudio, the program
we'll use to work with R. Start by going to the RStudio home page:
[https://rstudio.com](https://rstudio.com). 

At the very top, you'll see a link to "Downloads": click that.

![Rstudio homepage]({{ site.baseurl }}/{{ site.img }}/rstudio_home.png)

You'll be presented with a number of versions of RStudio to
install. We'll choose the free desktop version (naturally!).

![RStudio version selection]({{ site.baseurl }}/{{ site.img }}/rstudio_version.png)

You'll now see a button to download RStudio. Step (1) is to download
R, but we've already done that so we're good. 

One thing: the RStudio website is smart and tries to guess your OS so
that it can present you with a big button to download the correct
version. As you can see, it worked for me: I'm shown a button to
download RStudio for MacOS. If you go to the website on a computer
using Windows, the button should instead be a link to install RStudio
for Windows. If all works, then you can click the button either way
(yours just may look different), download, and install as normal. If
the button doesn't have your correct OS, then go to the next step.

![RStudio install button]({{ site.baseurl }}/{{ site.img }}/rstudio_install.png)

Just below the big button, you'll see the full list of RStudio
versions. You can also pick your correct version here. Same as before,
just click the link, download, and install as normal.

![RStudio install options]({{ site.baseurl }}/{{ site.img }}/rstudio_install_opt.png)

# Installing git

There are two things you need to do to use git/GitHub in our course:
(1) have an installation of git and (2) have a GitHub account. Rather
than reinventing the wheel, I suggest following the instructions from
Jenny Bryan.

1. [Get a GitHub account](https://happygitwithr.com/github-acct.html)
1. [Install git on your
   computer](https://happygitwithr.com/install-git.html)

**NOTE** As part of registering an account with GitHub, I recommend
requesting an [Education Discount so you can get free private
repositories for future work](https://happygitwithr.com/github-acct.html#free-private-repos).

# Installing LaTeX

LaTeX is a document typesetting system/language. While it's probably
best known for its ability to nicely typeset mathematical equations,
LaTeX works really well quantitative research workflows. That said, it
can be difficult to install and work with.

We'll use LaTeX later in the semester so that you can make nice PDF
reports. The good news is that you won't really need to interact with
LaTeX at all to do so --- other than to install it now. 

Since you don't need a full TeX distribution on your computer, you can
most likely get by using the [TinyTeX](https://yihui.org/tinytex/)
distribution that we can install directly from R. If you want a full
version of TeX on your computer (**NOTE:** It's very large), then skip
to the full installation for your computer.

## TinyTex

Once you've installed R and RStudio, open RStudio and type the
following in the Console:

```r
install.packages("tinytex")
tinytex::install_tinytex()
```

This will install the `tinytex` R package and then install the TinyTeX
distribution (it may take a minute or two).

## OPTIONAL: Full installation

If you want the full installation, first go the LaTeX home page at
[https://www.latex-project.org](https://www.latex-project.org).

![]({{ site.baseurl }}/{{ site.img }}/latex_home.png)

If you scroll down slightly, you'll see options for MacOS (MacTeX) and
Windows (MiKTeX) installations. Click the link that applies to your OS
and follow the instructions below.

![]({{ site.baseurl }}/{{ site.img }}/latex_install.png)

### LaTeX for MacOS (MacTeX)

On the MacTeX home page, first click the link for the MacTeX Download.

![]({{ site.baseurl }}/{{ site.img }}/mactex_first.png)

On the next page, click the link for MacTeX.pkg, agree to download,
and then double click on the downloaded file to install. Note that
this package is very big (~ 4GB) because you are downloading just
about everything TeX-related, including some software. It's what I
use, but I use TeX all the time. Just know this in case your storage
space is limited on your computer.

![]({{ site.baseurl }}/{{ site.img }}/mactex_download.png)


### LaTeX for Windows (MiKTeX)

Once you reach the Windows (MiKTeX) homepage, click the Downloads link
at the top of the page.

![]({{ site.baseurl }}/{{ site.img }}/miktex_home.png)


On the next screen, you'll want to click on the blue "Download"
button, agree to the download, and then install.

![]({{ site.baseurl }}/{{ site.img }}/miktex_download.png)

**ONE NOTE** MiKTeX is much smaller than MacTeX, but that's because it
doesn't download everything. Instead, it opts to only install packages
as you need them. Cool, expect that doesn't always work well with
RStudio. 

The fix is this: when going through the installation, on the
"Settings" screen, be sure to change the default selection for
"Install missing packages on-the-fly" from `"Ask me first"` to
`"Always"`. Continue the installation with the other default options.

![]({{ site.baseurl }}/{{ site.img }}/miktex_settings.png)


