module Adauth
    module AdObjects
        # Active Directory Computer Object
        #
        # Inherits from Adauth::AdObject
        class Computer < Adauth::AdObject
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
            Fields = {
                    :name => :name
                }
            
            # Object Net::LDAP filter
            #
            # Used to restrict searches to just this object
            ObjectFilter = Net::LDAP::Filter.eq("objectClass", "computer")
            
            handle_missingly Fields.keys do |field|
              return handle_field(Fields[field])
            end
        end
    end
end