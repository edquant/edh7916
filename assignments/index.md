---
layout: default
title: Assignments
---

Students are expected to complete the following assignments as part of
the course (percentage of final grade in parentheses): 

- **Class participation (10%):** We will use class time to work
  through lesson modules together. Students are expected to follow
  along with the presentation and run code on their own
  machine. Students are also expected to answer questions and work
  through example problems throughout the class session.

- **Problem sets (45%):**Every lesson module will end with a set of
  questions that students must answer. Students can work together to
  solve the problem sets, but everyone must submit their own work and
  do their best to give accurate attribution for borrowed/repurposed
  code. In general, problem set answers will need to be submitted via
  GitHub a week after they are assigned.
  
  There are a few supplemental lessons that include supplemental
  assignments. Though these are not required, you may find them
  useful. Please note that the supplemental assignments may be more
  difficult than the normal problem set assignments. Students may
  complete more than the required numbered of lessons during the
  second half of the course and submit the problem sets as
  supplemental assignments. Students may replace up to two (2) problem
  set submissions with submissions from the supplemental assignments.
  
- **Reproducible report (45%):** Everyone must produce a 3-5 page
  report on a higher education topic of interest. The report should be
  a combination of writing, tables, and figures, have minimal
  citations (if any), and be fully reproducible with minimal
  effort. You must use data that is either publicly available or that
  can be shared with others (no IRB restrictions). Everyone will
  submit three preliminary assignments in addition to the final
  report. Each product is worth the following percentage of the final
  grade:
  - Proposal (5%)  
  - Initial set of analyses (10%)  
  - Draft of final report (10%)  
  - Final report (15%)  
  - Presentation (5%)
  
## Assignments

<ul class="assignments">
{% assign probset = site.assignments | where: 'category', 'problemset' %}
{% assign probset = probset | sort:"order"  %}
{% for ps in probset %}
	<li class="do">
		<a href="{{ ps.url | prepend: site.baseurl }}.html">{{ ps.title }}</a>
	</li>
{% endfor %}
</ul>

## Supplemental assignments

<ul class="assignments">
{% assign sup = site.assignments | where: 'category', 'supplemental' %}
{% assign sup = sup | sort:"order"  %}
{% for s in sup %}
	<li class="do">
		<a href="{{ s.url | prepend: site.baseurl }}.html">{{ s.title }}</a>
	</li>
{% endfor %}
</ul>

## Final project

<ul class="assignments">
{% assign finalproj1 = site.assignments | where: 'category', 'finalproject' %}
{% assign finalproj2 = site.assignments | where: 'category', 'rubric' %}
{% assign finalproj = finalproj1 | concat: finalproj2 %}
{% assign finalproj = finalproj | sort:"order"  %}
{% for fp in finalproj %}
{% if fp.category == "rubric" %}
<li class="rubric">
	<a href="{{ fp.url | prepend: site.baseurl }}.html">{{ fp.title }}</a>
</li>
{% else %}
<li class="do">
	<a href="{{ fp.url | prepend: site.baseurl }}.html">{{ fp.title }}</a>
</li>
{% endif %}
{% endfor %}
</ul>
