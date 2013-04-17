# Requires
require 'net/ldap'
require 'timeout'
# Version
require 'adauth/version'
# Classes
require 'adauth/ad_object'
require 'adauth/authenticate'
require 'adauth/config'
require 'adauth/connection'
# AdObjects
require 'adauth/ad_objects/computer'
require 'adauth/ad_objects/folder'
require 'adauth/ad_objects/group'
require 'adauth/ad_objects/ou'
require 'adauth/ad_objects/user'
# Rails
require 'adauth/rails'
require 'adauth/rails/helpers'
require 'adauth/rails/model_bridge'

# Adauth Container Module
module Adauth
    # Yields a new config object and then sets it as the Adauth Config
    def self.configure
        @config = Config.new
        yield(@config)
    end
    
    # Returns Adauths current connection to ActiveDirectory
    def self.connection
        raise 'Adauth needs configuring before use' if @config == nil
        connect unless @connection
        @connection
    end
    
    # Connects to ActiveDirectory using the query user details
    def self.connect
        @connection = Adauth::Connection.new(connection_hash(@config.query_user, @config.query_password)).bind
    end
    
    # Generates a hash for the connection class, takes a username and password
    def self.connection_hash(user, password)
        { 
            :domain => @config.domain, 
            :server => @config.server, 
            :port => @config.port, 
            :base => @config.base, 
            :encryption => @config.encryption, 
            :username => user, 
            :password => password 
        }
    end
end