module Adauth
    module AdObjects
        # Active Directory User Object
        #
        # Inherits from Adauth::AdObject
        class User < Adauth::AdObject
            # Field mapping
            #
            # Maps methods to LDAP fields e.g.
            #
            # :foo => :bar
            #
            # Becomes
            # 
            # Computer.name
            #
            # Which calls .name on the LDAP object
            Fields = { :login => :samaccountname,
                    :first_name => :givenname,
                    :last_name => :sn,
                    :email => :mail,
                    :name => :name,
                    :cn_groups => [ :memberof,
                        Proc.new {|g| g.sub(/.*?CN=(.*?),.*/, '\1')} ]
                    }
              
            # Object Net::LDAP filter
            #
            # Used to restrict searches to just this object      
            ObjectFilter = Net::LDAP::Filter.eq('objectClass', 'user')
          
            # Returns a connection to AD within the users context, used to check a user credentails
            #
            # Using this would by pass the group and OU Filtering provided by Adauth#authenticate
            def self.authenticate(user, password)
                user_connection = Adauth::Connection.new(Adauth.connection_hash(user, password)).bind
            end
            
            # Returns True/False if the user is member of the supplied group
            def member_of?(group)
                cn_groups.include?(group)
            end
        end
    end
end