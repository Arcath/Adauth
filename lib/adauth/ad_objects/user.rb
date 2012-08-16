module Adauth
    module AdObjects
        class User < Adauth::AdObject
            Fields = { :login => :samaccountname,
                    :first_name => :givenname,
                    :last_name => :sn,
                    :email => :mail,
                    :name => :name,
                    :cn_groups => [ :memberof,
                        Proc.new {|g| g.sub(/.*?CN=(.*?),.*/, '\1')} ]
                    }
                    
            ObjectFilter = Net::LDAP::Filter.eq("objectClass", "user")
                    
            def self.authenticate(user, password)
                user_connection = Adauth::Connection.new(Adauth.connection_hash(user, password)).bind
            end
            
            def member_of?(group)
                cn_groups.include?(group)
            end
        end
    end
end