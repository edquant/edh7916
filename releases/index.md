---
layout: default
title: Releases
date: 2020-01-08 00:00:00
---

As the course website is updated, either to add lessons and
assignments, correct bugs, or make general changes, I tag each version
with a release number. This allows users to see all changes over time
and go back to earlier versions of the class if necessary.

Releases pull directly from
[GitHub](https://github.com/edquant/edh7916/releases). Release
numbers, `v<1>.<2>.<3>` follow the general format of:

- `<1>`: Course
- `<2>`: Lesson / Assignment update
- `<3>`: Bug fixes and small website updates

{% for release in site.github.releases %}

# [{{ release.name }}]({{ release.html_url }})

{{ release.body }}

{% endfor %}
