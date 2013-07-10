module Adauth
    # Authenticates the specifed user agains the domain
    #
    # Checks the groups & ous are in the allow/deny lists
    def self.authenticate(username, password)
        begin
            Adauth.logger.info("authentication") { "Attempting to authenticate as #{username}" }
            if Adauth::AdObjects::User.authenticate(username, password)
                user = Adauth::AdObjects::User.where('sAMAccountName', username).first
                if allowed_group_login(user) && allowed_ou_login(user)
                    Adauth.logger.info("authentication") { "Authentication succesful" }
                    return user
                else
                    Adauth.logger.info("authentication") { "Authentication failed (not in allowed group)" }
                    return false
                end
            end
        rescue RuntimeError
            Adauth.logger.info("authentication") { "Authentication failed (RuntimeError)" }
            return false
        end
    end
    
    # Makes sure the user meets the group requirements
    def self.allowed_group_login(user)
      return true if @config.allowed_groups.empty? && @config.denied_groups.empty?
      return true if !((@config.allowed_groups & user.cn_groups_nested).empty?)
      return false if !((@config.denied_groups & user.cn_groups_nested).empty?)
    end
    
    # Makes sure the user meets the ou requirements
    def self.allowed_ou_login(user)
        return true if @config.allowed_ous.empty? && @config.denied_ous.empty?
        return true if !((@config.allowed_ous & user.dn_ous).empty?)
        return false if !((@config.denied_ous & user.dn_ous).empty?)
    end
end
