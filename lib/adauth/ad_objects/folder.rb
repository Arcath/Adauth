module Adauth
    module AdObjects
        # Active Directory OU Object
        #
        # Inherits from Adauth::AdObject
        class Folder < Adauth::AdObject
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
            ObjectFilter = Net::LDAP::Filter.eq("objectClass", "top")
            
            def self.root
              self.new(Adauth.connection.search(:filter => Net::LDAP::Filter.eq("objectClass", "Domain")).first)
            end
        end
    end
end