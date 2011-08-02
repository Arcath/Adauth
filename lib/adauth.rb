require 'net/ldap'
require 'adauth/version'
require 'adauth/user'
require 'adauth/config'
require 'adauth/helpers'
require 'adauth/user_model' if defined? ActiveRecord

# The top level module
#
# For Adauths documentation please see the github wiki.
module Adauth
    
    # Takes a username and password as an input and returns an instance of `Adauth::User`
    #
    # Called as
    #    Adauth.authenticate("Username", "Password")
    #
    # Will return `nil` if the username/password combo is wrong, if the username/password combo is correct it will return an instance of `Adauth::User` which can be used to populate your database.
    def self.authenticate(login, pass)
        if @config.allowed_groups != []
            user = Adauth::User.authenticate(login, pass)
            (user && @config.allowed_groups != (@config.allowed_groups - user.groups)) ? user : nil
        elsif @config.denied_groups != []
            user = Adauth::User.authenticate(login, pass)
            (user && @config.denied_groups == (@config.denied_groups - user.groups)) ? user : nil
        elsif @config.allowed_ous != []
            user = Adauth::User.authenticate(login, pass)
            (user && @config.allowed_ous != (@config.allowed_ous - user.ous)) ? user : nil
        elsif @config.denied_ous != []
            user = Adauth::User.authenticate(login, pass)
            (user && @config.denied_ous == (@config.denied_ous - user.ous)) ? user : nil
        else
            Adauth::User.authenticate(login, pass)
        end
    end
    
    # Used to configure Adauth
    #
    # Called as
    #    Adauth.configure do |c|
    #        c.foo = "bar"
    #    end
    #
    # Configures Adauth and is required for Adauth to work.
    def self.configure
       @config = Config.new
       yield(@config) 
    end
    
    # Returns the config object
    #
    # Allows access to the adauth config object so you can call the config values in your application
    def self.config
        @config
    end
    
    # Rails generators
    module Generators
    end
end
