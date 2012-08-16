module Adauth
    module AdObjects
        class OU < Adauth::AdObject
            Fields = {
                    :name => :name
                }
            
            ObjectFilter = Net::LDAP::Filter.eq("objectClass", "organizationalUnit")
            
            def members
                unless @members
                    @members = []
                    [Adauth::AdObjects::Computer].each do |object|
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