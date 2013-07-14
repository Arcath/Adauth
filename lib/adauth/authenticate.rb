module Adauth
    # Authenticates the specifed user agains the domain
    #
    # Checks the groups & ous are in the allow/deny lists
    def self.authenticate(username, password)
        begin
            Adauth.logger.info("authentication") { "Attempting to authenticate as #{username}" }
            if Adauth::AdObjects::User.authenticate(username, password)
                user = Adauth::AdObjects::User.where('sAMAccountName', username).first
                if allowed_to_login(user)
                    Adauth.logger.info("authentication") { "Authentication succesful" }
                    return user
                else
                    Adauth.logger.info("authentication") { "Authentication failed (not in allowed group or ou)" }
                    return false
                end
            end
        rescue RuntimeError
            Adauth.logger.info("authentication") { "Authentication failed (RuntimeError)" }
            return false
        end
    end
    
    # Check if the user is allowed to login
    def self.allowed_to_login(user)
      (allowed_from_arrays(@config.allowed_groups, @config.denied_groups, user.cn_groups_nested) && allowed_from_arrays(@config.allowed_ous, @config.denied_ous, user.dn_ous))
    end
    
    private
    
    def self.allowed_from_arrays(allowed, denied, test)
      return true if allowed.empty? && denied.empty?
      return true if !((allowed & test).empty?)
      return false if !((denied & test).empty?)
    end
end
