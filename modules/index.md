---
layout: default
---

# Modules

Workshop modules are listed in order of the course. The R script
(<span><i class="fas fa-code"></i></span>) and data (<span><i
class="fas fa-database"></i></span>) used to create each module will be
linked at the top of the page. Alternately, all scripts and data may
be 

* Downloaded as a <a href="{{ site.zip }}" download="{{ site.course }}">zip file</a>
* Cloned in bulk from the workshop's [GitHub
repository]({{ site.repo }}).

<ul class="modules">
{% for module in site.modules %}
	<li>
		<a href="{{ module.url | prepend: site.baseurl }}.html">{{ module.title }}</a>
	</li>
{% endfor %}
</ul>

## Directory structure

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
