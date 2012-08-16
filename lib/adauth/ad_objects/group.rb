module Adauth
    module AdObjects
        class Group < Adauth::AdObject
            Fields = {
                    :name => :samaccountname,
                    :cn_members => [ :member,
                        Proc.new {|g| g.sub(/.*?CN=(.*?),.*/, '\1')} ],
                    :cn_groups => [ :memberof,
                        Proc.new {|g| g.sub(/.*?CN=(.*?),.*/, '\1')} ]
                }
                
            ObjectFilter = Net::LDAP::Filter.eq("objectClass", "group")
                
            def members
                unless @members
                    @members = convert_to_objects(cn_members)
                end
                @members
            end
        end
    end
end