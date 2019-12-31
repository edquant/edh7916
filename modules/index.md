---
layout: default
title: Modules
---

Workshop modules are listed in order of the course. The R script
(<span><i class="fas fa-code"></i></span>) and data (<span><i
class="fas fa-database"></i></span>) used to create each module will be
linked at the top of the page. 

<ol class="modules">
{% assign modules = site.modules | sort:"order"  %}
{% for m in modules %}
	<li>
		<a href="{{ m.url | prepend: site.baseurl }}.html">{{ m.title }}</a>
	</li>
{% endfor %}
</ol>

## A note on directory structure

All modules assume the following directory structure:

```
edh7916/
|
|__ data/
|   |
|   |-- module1.data
|   |-- module2.data
|   |...
|
|__ scripts/
|   |
|   |-- module1.R
|   |-- module2.R
|   |...
```

For all scripts, the working directory should be `path/to/scripts`.
