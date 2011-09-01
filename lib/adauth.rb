require 'net/ldap'
require 'adauth/version'
require 'adauth/user'
require 'adauth/config'
require 'adauth/helpers'
require 'adauth/connection'
require 'adauth/group'
require 'adauth/admin_connection'
require 'adauth/authenticate'
require 'adauth/user_model'

# The top level module
#
# For Adauths documentation please see the github wiki.
module Adauth
    
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
