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

            if allowed == nil
              allowed = is_group_in_group(user) != nil ? user : nil
            end
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

  def self.is_group_in_group(adobject)
    # Loop through each users group and see if it's a member of an allowed group
    begin
      adobject.cn_groups.each do |group|

        if @config.allowed_groups.include?(group)
          return group
        end

        adGroup = Adauth::AdObjects::Group.where('name', group).first

        unless self.is_group_in_group(adGroup) == nil
          return true
        end
      end
    rescue
      return nil
    end

    nil
  end
end
