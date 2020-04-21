---
layout: page
title: "Graphs"
permalink: /graphs/
---

Here's a repository of various graphs I've made over the years. Most of these are for my intro to IR class but there are a few graphs here I've made for other purposes. I place these here as a means of disseminating information about various things in the world for a more general audience.

And yes, as soon as I can figure out more of [Jekyll](https://jekyllrb.com/) to make this page useful, I'll do it.

<ul id="archive">


{% for gallery in site.data.graphs %}
  {% if graph.id == page.galleryid %}
    <h1>{{ graph.description }}</h1>
    {% assign sortedimages = gallery.images | sort: 'title' %}
    {% for image in sortedimages %}
      <li class="archiveposturl">
        <span><a href="{{ site.url }}/graphs/{{ image.file }}">{{image.title }}</a></span><br>
<span class = "postlower">{{ image.caption }}<br />
<strong>Tags:</strong> {{ image.tags }}</span>
      </li>
    {% endfor %}
  {% endif %}
{% endfor %}

</ul>


