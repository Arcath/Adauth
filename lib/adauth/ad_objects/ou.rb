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
            
            # Returns all objects contained with in this OU
            def members
                unless @members
                    @members = []
                    [Adauth::AdObjects::Computer, Adauth::AdObjects::Group, Adauth::AdObjects::User].each do |object|
                        object.all.each do |entity|
                            @members.push entity if entity.ldap_object.dn =~ /#{@ldap_object.dn}/
                        end
                    end
                end
                @members
            end
        end
    end
end