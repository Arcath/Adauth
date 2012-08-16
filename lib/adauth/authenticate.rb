module Adauth
    # Authenticates the specifed user agains the domain
    #
    # Checks the groups & ous are in the allow/deny lists
    def self.authenticate(username, password)
        begin
            if Adauth::AdObjects::User.authenticate(username, password)
                user = Adauth::AdObjects::User.where('sAMAccountName', username).first
                if allowed_group_login(user) && allowed_ou_login(user)
                    return user
                else
                    return false
                end
            else
                return false
            end
        rescue RuntimeError
            return false
        end
    end
    
    # Makes sure the user meets the group requirements
    def self.allowed_group_login(user)
        if @config.allowed_groups != []
            allowed = (user && @config.allowed_groups != (@config.allowed_groups - user.cn_groups)) ? user : nil
        else
            allowed = user
        end

        if @config.denied_groups != []
            denied = (user && @config.denied_groups == (@config.denied_groups - user.cn_groups)) ? user : nil
        else
            denied = user
        end
        allowed == denied
    end
    
    # Makes sure the user meets the ou requirements
    def self.allowed_ou_login(user)
        if @config.allowed_ous != []
            allowed = (user && @config.allowed_ous != (@config.allowed_ous - user.dn_ous)) ? user : nil
        else
            allowed = user
        end

        if @config.denied_ous != []
            denied = (user && @config.denied_ous == (@config.denied_ous - user.dn_ous)) ? user : nil
        else
            denied = user
        end
        allowed == denied
    end
end
