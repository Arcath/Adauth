# Adauth
[RDoc](http://rubydoc.info/github/Arcath/Adauth/master/frames) | [www](http://adauth.arcath.net) | [Gempage](http://rubygems.org/gems/adauth) | [![Status](https://secure.travis-ci.org/Arcath/Adauth.png?branch=master)](http://travis-ci.org/Arcath/Adauth) | [![Code Climate](https://codeclimate.com/github/Arcath/Adauth.png)](https://codeclimate.com/github/Arcath/Adauth) | [![Dependency Status](https://gemnasium.com/Arcath/Adauth.png)](https://gemnasium.com/Arcath/Adauth)


Easy to use Active Directory Authentication for Rails.

## Install

Add the Adauth gem to your Gemfile:

    gem 'adauth'

and run a bundle install

## Usage

### In Rails

First off create a new config file by running the config generator

    rails g adauth:config

Fill out the config values in _config/initializers/adauth.rb_

#### Joining a model to Adauth

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

#### SessionsController

You can use a premade sessions controller by running

    rails g adauth:sessions
	
Which adds a couple of routes, a sessions controller and a login form. To login go to _/sessions/new_ and fill out the form, you will then POST to _/adauth_ and if succesful you will be sent back to _root_path_

### In Scripts

To use Adauth in a script or other program just call `Adauth.configure` somewhere at the begining of the script, once configured Adauth can be used anywhere in your program the same as rails.

## Configuring

Adauth has a few configuration options which are described in detail on the [wiki](https://github.com/Arcath/Adauth/wiki/Configuring).

## Logs

Adauth logs to weekly logs in logs/adauth.log(.DATE)

You can interact with the logger through `Adauth.logger` and set a new one using `Adauth.logger=`

## Developing

Before you can run the tests you will need to write a yml file with your domain settings in and place it at _spec/test_data.yml_, there is an example of this file in the spec folder.

When you fork Adauth please:

1. Create your feature branch (`git checkout -b my-new-feature`)
2. Commit your changes (`git commit -am 'Add some feature'`)
3. Push to the branch (`git push origin my-new-feature`)
4. Create new Pull Request
