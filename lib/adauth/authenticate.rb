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

    # Authenticates the user against the domain without using the query user
    #
    # Checks the groups & ous are in the allow/deny lists
    def self.simple_authenticate(username, password)
      begin
        Adauth.logger.info("authentication") { "Attempting to simple authenticate as #{username}" }
        user_connection = Adauth::AdObjects::User.authenticate(username, password)
        if user_connection
          search_filter = Net::LDAP::Filter.eq('SAMAccountName', username) & Net::LDAP::Filter.eq('objectClass', 'user')
          results = user_connection.search(filter: search_filter)
          user = Adauth::AdObjects::User.new(results[0])
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
      if (@config.allowed_groups.empty? && @config.allowed_ous.empty?) && (@config.denied_groups.empty? && @config.denied_ous.empty?)
        return true
      else
        return (allowed_from_arrays(@config.allowed_groups, @config.denied_groups, user.cn_groups_nested) && allowed_from_arrays(@config.allowed_ous, @config.denied_ous, user.dn_ous))
      end
    end

    private

    def self.allowed_from_arrays(allowed, denied, test)
      return true if allowed.empty? && denied.empty?
      return true if !((allowed & test).empty?)
      return false if !((denied & test).empty?)
    end
end
