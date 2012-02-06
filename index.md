---
layout: page
title: Home
---

## About

Adauth provides Windows Active Directory authentication for Rails. To install it simply add this to your Gemfile

    gem 'adauth'

Then create _config/initializers/adauth.rb_ and put this in it:

    Adauth.configure do |c|
        c.domain = "example.com"
		c.server = "dc.example.com"
		c.base = "dc=example, dc=com"
    end

And thats it!

You can now authenticate users against the domain by calling:

    Adauth.authenticate("Username", "Password")

Adauth does have a lot more config available, such as group/ou filtering.

## Guides

<ul>
	<li><a href="{{ BASE_PATH }}install.html">Install</a></li>
	<li><a href="{{ BASE_PATH }}configuring.html">Configuring</a></li>
</ul>

## News

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>