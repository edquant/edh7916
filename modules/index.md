---
layout: default
title: Modules
---

Workshop modules are listed in order of the course. The R script
(<span><i class="fas fa-code"></i></span>) and data (<span><i
class="fas fa-database"></i></span>) used to create each module will be
linked at the top of the page. 

## A note on directory structure

All modules assume the directory structure below. 

```
student_<your_last_name>/
|
|__ data/
|   |
|   |-- module1.rds
|   |-- module2.rds
|   |...
|
|__ scripts/
|   |
|   |-- module1.R
|   |-- module2.R
|   |...
```

When running scripts in RStudio, the working directory should be
`path/to/student_<your_last_name>/scripts`. You can check in RStudio
by typing `getwd()` in the console. For example, let's say you've
cloned your personal repo into your home directory within a folder
called `edh7916`. Then you should see (if on a Mac):

```r
> getwd()
[1] "/Users/bts/edh7916/student_skinner/scripts"
```

## Lessons

<ol class="modules">
{% assign modules = site.modules | sort:"order"  %}
{% for m in modules %}
	<li>
		<a href="{{ m.url | prepend: site.baseurl }}.html">{{ m.title }}</a>
	</li>
{% endfor %}
</ol>
