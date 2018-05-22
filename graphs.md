---
layout: page
title: "Graphs"
permalink: /graphs/
---

Here's a repository of various graphs I've made over the years. Most of these are for my intro to IR class but there are a few graphs here I've made for other purposes. I place these here as a means of disseminating information about various things in the world for a more general audience.

And yes, as soon as I can figure out more of [Jekyll](https://jekyllrb.com/) to make this page useful, I'll do it.

<ul id="archive">

{% for image in site.static_files %}
{% capture filename %}{{ filename | remove:remove }}{% endcapture %}
    {% if image.path contains 'graphs' %}
        <li class="archiveposturl"><span><a href="{{ site.baseurl }}{{ image.path }}" alt="image" >{{ image.path | remove: '/graphs/' }}</a></span></li>
    {% endif %}
{% endfor %}
</ul>