# Requires
require 'net/ldap'
require 'timeout'
# Version
require 'adauth/version'
# Classes
require 'adauth/ad_object'
require 'adauth/config'
require 'adauth/connection'
# AdObjects
require 'adauth/ad_objects/computer'
require 'adauth/ad_objects/group'
require 'adauth/ad_objects/ou'
require 'adauth/ad_objects/user'
# Rails


# Main Module
module Adauth
    
    def self.configure
        @config = Config.new
        yield(@config)
    end
    
    def self.connection
        raise "Adauth needs configuring before use" if @config == nil
        connect unless @connection
        @connection
    end
    
    def self.connect
        @connection = Adauth::Connection.new(connection_hash(@config.query_user, @config.query_password)).bind
    end
    
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