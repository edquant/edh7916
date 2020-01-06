---
layout: default
title: Lessons
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
|   |-- lesson1.rds
|   |-- lesson2.rds
|   |...
|
|__ scripts/
|   |
|   |-- lesson1.R
|   |-- lesson2.R
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

<ol class="lessons">
{% assign lessons = site.lessons | where: 'category', 'lesson' %}
{% assign lessons = lessons | sort:"order"  %}
{% for l in lessons %}
	<li>
		<a href="{{ l.url | prepend: site.baseurl }}.html">{{ l.title }}</a>
	</li>
{% endfor %}
</ol>

## Supplemental

<ul class="lessons">
{% assign supplemental = site.lessons | where: 'category', 'supplemental' %}
{% assign supplemental = supplemental | sort:"order"  %}
{% for s in supplemental %}
	<li>
		<a href="{{ s.url | prepend: site.baseurl }}.html">{{ s.title }}</a>
	</li>
{% endfor %}
</ul>
