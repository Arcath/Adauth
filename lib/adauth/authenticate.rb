module Adauth
    # Takes a username and password as an input and returns an instance of `Adauth::User`
    #
    # Called as
    #    Adauth.authenticate("Username", "Password")
    #
    # Will return `nil` if the username/password combo is wrong, if the username/password combo is correct it will return an instance of `Adauth::User` which can be used to populate your database.
    def self.authenticate(login, pass)
        if user = Adauth::User.authenticate(login, pass)
            return user if allowed_group_login(user) and allowed_ou_login(user)
        else
            return nil
        end
    end
    
    def self.allowed_group_login(user)
        if @config.allowed_groups != []
            allowed = (user && @config.allowed_groups != (@config.allowed_groups - user.groups)) ? user : nil
        else
            allowed = user
        end
        
        if @config.denied_groups != []
            denied = (user && @config.denied_groups == (@config.denied_groups - user.groups)) ? user : nil
        else
            denied = user
        end
        
        allowed == denied
    end
    
    def self.allowed_ou_login(user)
        if @config.allowed_ous != []
            allowed = (user && @config.allowed_ous != (@config.allowed_ous - user.ous)) ? user : nil
        else
            allowed = user
        end
        
        if @config.denied_ous != []
            denied = (user && @config.denied_ous == (@config.denied_ous - user.ous)) ? user : nil
        else
            denied = user
        end
        
        allowed == denied
    end
end