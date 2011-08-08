module Adauth
    
    # Active Directory Group object
    class Group
        
        ATTR_SV = {
            :name => :name
        }
        
        ATTR_MV = {}
        
        def self.find(name)
            @conn = Adauth::AdminConnection.bind
            if group = @conn.search(:filter => Net::LDAP::Filter.eq('name', name)).first
                return self.new(group)
            else
                return nil
            end
        end
        
        def members
            #(objectCategory=user)(memberOf=CN=QA Users,OU=Help Desk,DC=dpetri,DC=net) 
            members_ldap = @conn.search(:filter => Net::LDAP::Filter.eq('objectCategory', 'user'))
            members = []
            members_ldap.each do |member|
                user = Adauth::User.create_from_group(member.samaccountname.first)
                members.push(user) if user.groups.include?(name)
            end
            return members
        end
        
        private
        
        def initialize(entry)
            @entry = entry
            @conn = Adauth::AdminConnection.bind
            self.class.class_eval do
                generate_single_value_readers
                generate_multi_value_readers
            end
        end

        def self.generate_single_value_readers
            ATTR_SV.merge(Adauth.config.ad_sv_group_attrs).each_pair do |k, v|
                val, block = Array(v)
                define_method(k) do
                    if @entry.attribute_names.include?(val)
                        if block.is_a?(Proc)
                            return block[@entry.send(val).to_s]
                        else
                            return @entry.send(val).to_s
                        end
                    else
                        return ''
                    end
                end
            end
        end

        def self.generate_multi_value_readers
            ATTR_MV.merge(Adauth.config.ad_mv_group_attrs).each_pair do |k, v|
                val, block = Array(v)
                define_method(k) do
                    if @entry.attribute_names.include?(val)
                        if block.is_a?(Proc)
                            return @entry.send(val).collect(&block)
                        else
                            return @entry.send(val)
                        end
                    else
                        return []
                    end
                end
            end
        end
    end
end