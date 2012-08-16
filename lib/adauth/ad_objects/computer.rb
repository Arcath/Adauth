module Adauth
    module AdObjects
        class Computer < Adauth::AdObject
            Fields = {
                    :name => :name
                }
                
            ObjectFilter = Net::LDAP::Filter.eq("objectClass", "computer")
        end
    end
end