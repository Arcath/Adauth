module Adauth
    module AdObjects
        # Active Directory OU Object
        #
        # Inherits from Adauth::AdObject
        class OU < Adauth::AdObject
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
            ObjectFilter = Net::LDAP::Filter.eq("objectClass", "organizationalUnit")
            
            handle_missingly Fields.keys do |field|
              return handle_field(Fields[field])
            end
        end
    end
end