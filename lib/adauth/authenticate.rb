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
    
    # Takes a username as an input and returns and instance of `Adauth::User`
    # 
    # Called as
    #    Adauth.authentication("Username")
    #
    # Will return `nil` if the username is worng, if the admin details are not set an error will be raised.
    def self.passwordless_login(login)
        @conn = Adauth::AdminConnection.bind
        if user = @conn.search(:filter => Net::LDAP::Filter.eq('sAMAccountName', login))
            return Adauth::User.new(user.first)
        else
            return nil
        end
    end
    
    # Checks weather an users groups are allowed to login
    #
    # Called as:
    #    Adauth.allowed_group_login(Adauth::User)
    #
    # Returns true if the user can login and false if the user cant
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
    
    # Checks weather an users ous are allowed to login
    #
    # Called as:
    #    Adauth.allowed_ou_login(Adauth::User)
    #
    # Returns true if the user can login and false if the user cant
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