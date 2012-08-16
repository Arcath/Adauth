# Adauth
[RDoc](http://rubydoc.info/github/Arcath/Adauth/master/frames) | [www](http://adauth.arcath.net) | [Gempage](http://rubygems.org/gems/adauth) | [![Status](https://secure.travis-ci.org/Arcath/Adauth.png?branch=master)](http://travis-ci.org/Arcath/Adauth)

Easy to use Active Directory Authentication for Rails.

## Install

Add the Adauth gem to your Gemfile:

    gem 'adauth'

and run a bundle install

## Usage

First off create a new config file by running the config generator

    rails g adauth:config

Fill out the config values in _config/initializers/adauth.rb_

### Joining a model to Adauth

If you want to link your user model to Adauth you can use this simple code:

    class User < ActiveRecord::Base
		include Adauth::Rails::ModelBridge
		
		AdauthMappings = {
			:login => :login
			:group_strings => :cn_groups
		}
		
		AdauthSearchField = [:login, :login]
	end
	
This gives you a bridge between Adauth and your model. When you call `User.create_from_adauth(adauth_model)` it does:

    u = User.new
    u.login = adauth_model.login
	u.group_strings = adauth_model.cn_groups
	u.save
	
This can be used for any model and anything that you pull over through adauth.

### SessionsController

TODO
