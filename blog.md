---
layout: page
title: Blog
permalink: /blog/
---

I blog semi-regularly about stuff. My blog entries typically focus on some professional development stuff for an intended audience of graduate students in my discipline. I also blog about some parlor tricks in LaTeX, R, or Markdown that I have taught myself and that might be worth sharing with the general public. A full listing of my blog posts follows.



<!-- {% assign sorted_cats = site.categories | sort  %}{% for category in sorted_cats %}<a href="" style="font-weight:normal;">{{category[0] | camelcase }}</a> ({{ category[1].size }}), {% endfor %} -->


<ul id="archive">
{% for post in site.posts %}
  {% capture y %}{{post.date | date:"%Y"}}{% endcapture %}
  {% if year != y %}
    {% assign year = y %}
    <h2 class="blogyear">{{ y}}</h2>
  {% endif %}
<li class="archiveposturl"><span><a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a></span><br/>
<span class = "postlower">

<!--<strong>Author:</strong> {{post.author}} -->
<strong>Category:</strong>  {% if post.categories %}
 
  {% for cat in post.categories %}
  <a href="/categories/#{{ cat }}" title="{{ cat }}">{{ cat }}</a>&nbsp;
  {% endfor %}

{% endif %} <!-- {{ post.categories | first }} -->
<strong style="font-size:100%; font-family: 'Titillium Web', sans-serif; float:right; padding-right: .5em">{{ post.date | date: '%d %b %Y' }}</strong> 
</span> 

</li>
{% endfor %}
</ul>

<!-- {{ post.date | date: '%m %d, %Y' }} -->
