---
layout: page
title: "Install"
tagline: "From Scratch"
---
{% include JB/setup %}

## Add the Gem

Step one is to add the gem to your _Gemfile_ like this:

    gem 'adauth'

## Run the generators

Adauth provides quite a few generators to help get you up and running, to run them all:

    rails g adauth:all

The generators give you instructions on how to do the final steps of the install.

## Configure Adauth

The _config_ generator creates a sample config file with every value listed with helpful comments. See <a href="{{ BASE_PATH }}configuring.html">Configuring</a> for more info.