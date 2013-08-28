# Requires
require 'expects'
require 'logger'
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

require 'adauth/net-ldap/string.rb' # Hot fix for issue

# Adauth Container Module
module Adauth  
    # Yields a new config object and then sets it as the Adauth Config
    def self.configure
        @logger ||= Logger.new('log/adauth.log', 'weekly')
        @logger.info('load') { "Loading new config" }
        @connection = nil
        @config = Config.new
        yield(@config)
    end
    
    # Returns Adauths current connection to ActiveDirectory
    def self.connection
        @logger.fatal('connection') { "Attempted to create connection without configuring" } if @config == nil
        raise 'Adauth needs configuring before use' if @config == nil # Still raise an error here even after logging it so that adauth stops dead and doesn't error on the next line
        connect unless @connection
        @connection
    end
    
    # Connects to ActiveDirectory using the query user details
    def self.connect
        @logger.info('connection') { "Connecting to AD as \"#{@config.query_user}\"" }
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
            :allow_fallback => @config.allow_fallback,
            :username => user, 
            :password => password,
            :anonymous_bind => @config.anonymous_bind 
        }
    end
    
    # Returns the logger object
    def self.logger
      @logger
    end
    
    # Lets you set a new logger
    def self.logger=(inputs)
      @logger = inputs
    end
end