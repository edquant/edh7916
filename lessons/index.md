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
edh7916/
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
`path/to/edh7916/scripts`. You can check in RStudio
by typing `getwd()` in the console. For example, let's say you've
saved the files in a folder called `courses`, which is in your home
directory. Then you should see (if on a Mac):

```r
> getwd()
[1] "/Users/benski/courses/edh7916/scripts"
```

## Lessons

<ul class="lessons">
{% assign lessons = site.lessons | where: 'category', 'lesson' %}
{% assign lessons = lessons | sort:"order"  %}
{% for l in lessons %}
	<li>
		<a href="{{ l.url | prepend: site.baseurl }}.html">{{ l.title }}</a>
	</li>
{% endfor %}
</ul>

## Extra

<ul class="lessons">
{% assign lessons = site.lessons | where: 'category', 'extra' %}
{% assign lessons = lessons | sort:"order"  %}
{% for l in lessons %}
	<li>
		<a href="{{ l.url | prepend: site.baseurl }}.html">{{ l.title }}</a>
	</li>
{% endfor %}
</ul>

## Supplemental

<ul class="supplemental">
{% assign supplemental = site.lessons | where: 'category', 'supplemental' %}
{% assign supplemental = supplemental | sort:"order"  %}
{% for s in supplemental %}
	<li>
		<a href="{{ s.url | prepend: site.baseurl }}.html">{{ s.title }}</a>
	</li>
{% endfor %}
</ul>
