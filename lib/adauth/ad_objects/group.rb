module Adauth
    module AdObjects
        # Active Directory Group Object
        #
        # Inherits from Adauth::AdObject
        class Group < Adauth::AdObject
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
                    :name => :samaccountname,
                    :cn_members => [ :member,
                        Proc.new {|g| g.sub(/.*?CN=(.*?),.*/, '\1')} ],
                    :cn_groups => [ :memberof,
                        Proc.new {|g| g.sub(/.*?CN=(.*?),.*/, '\1')} ]
                }
            
            # Object Net::LDAP filter
            #
            # Used to restrict searches' to just this object
            ObjectFilter = Net::LDAP::Filter.eq("objectClass", "group")
                
            # Returns all the objects which are members of this group
            def members
                unless @members
                    @members = convert_to_objects(cn_members)
                end
                @members
            end
        end
    end
end