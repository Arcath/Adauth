require 'net/ldap'
require 'adauth/version'
require 'adauth/user'
require 'adauth/config'
require 'adauth/helpers'
require 'adauth/user_model' if defined? ActiveRecord

module Adauth
    def self.authenticate(login, pass)
        if @config.allowed_groups != []
            user = Adauth::User.authenticate(login, pass)
            (user && @config.allowed_groups != (@config.allowed_groups - user.groups)) ? user : nil
        else
            Adauth::User.authenticate(login, pass)
        end
    end
    
    def self.configure
       @config ||= Config.new
       yield(@config) 
    end
    
    def self.config
        @config
    end
end
