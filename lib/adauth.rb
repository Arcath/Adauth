require 'net/ldap'
require 'adauth/version'
require 'adauth/user'
require 'adauth/config'

module Adauth
    def self.authenticate(login, pass)
        Adauth::User.authenticate(login, pass)
    end
    
    def self.configure
       @config = Config.new
       yield(@config) 
    end
    
    def self.config
        @config
    end
end