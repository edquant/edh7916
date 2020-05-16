---
layout: default
title: Assignments
---

Students are expected to complete the following assignments as part of
the course (percentage of final grade in parentheses): 

- **Problem sets (50%):** Every lesson module will have an associated
  set of questions that must be answered and submitted. You may work
  together and/or use online resources to solve the problem sets, but
  everyone must submit their own work and do their best to give
  accurate attribution for borrowed/repurposed code. There will be one
  problem set for each of ten (10) lessons, with each set worth 5% of
  the final grade. In general, problem set answers will need to be
  submitted via Canvas two (2) weeks after they are assigned.
  
  There are four (4) supplemental lessons — two before the mid-course
  break and two after — that will include supplemental
  assignments. Though these are not required, you may find them
  useful. You may replace up to two (2) problem set submissions with
  submissions from the supplemental assignments. Please note that the
  supplemental assignments may be more difficult than the normal
  problem set assignments.  
- **Reproducible report (50%):** Everyone must produce a 3-5 page
  report on a higher education topic of interest. The report should be
  a combination of writing, tables, and figures, have minimal
  citations (if any), and be fully reproducible with minimal
  effort. You must use data that is either publicly available or that
  can be shared with others (no IRB restrictions). Everyone will
  submit three preliminary assignments in addition to the final
  report. Each product is worth the following percentage of the final
  grade:
  - Proposal (5%)  
  - Initial set of analyses (15%)  
  - Draft of final report (15%)  
  - Final report (15%)  
  
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
