---
layout: default
title: Assignments
---

Students are expected to complete the following assignments as part of
the course (percentage of final grade in parentheses): 

- **Class participation (25%):** We will use class time to work through
  lesson modules together. Students are expected to follow along with
  the presentation and run code on their own machine. Students are
  also expected to answer questions and work through example problems
  throughout the class session. 
- **Problem sets (50%):** Every lesson module will end with a set of
  questions that students must answer. Students can work together to
  solve the problem sets, but everyone must submit their own work and
  do their best to give accurate attribution for borrowed/repurposed
  code. In general, problem set answers will need to be submitted via
  GitHub a week after they are assigned. 
- **Reproducible report (25%):** Students must produce a 3-5 page
  report on a higher education topic of interest. The report should be
  a combination of writing, tables, and figures, have minimal
  citations, and be fully reproducible with minimal effort. Students
  must use publicly available data. 
  
## Weekly assignments

<ol class="modules">
{% assign assignments = site.assignments | sort:"order"  %}
{% for a in assignments %}
	<li>
		<a href="{{ a.url | prepend: site.baseurl }}.html">{{ a.title }}</a>
	</li>
{% endfor %}
</ol>
