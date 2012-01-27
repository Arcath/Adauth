module Adauth
    
    # Active Directory Group object
    #
    # Called as:
    #    Adauth::Group.find(name)
    #
    # Returns an instance of Adauth::Group for the group specified in the find method
    class Group
        
        # Single vales where the method maps directly to one Active Directory attribute
        ATTR_SV = {
            :name => :name,
            :dn => :distinguishedname
        }
        
        # Multi values were the method needs to return an array for values.
        ATTR_MV = {
            :ous => [ :distinguishedname,
                           Proc.new {|g| g.sub(/.*?OU=(.*?),.*/, '\1')} ]
        }
        
        # Finds the group specified
        #
        # Called as:
        #    Adauth::Group.find(name)
        #
        # Returns an instance of Adauth::Group for the group specified in the find method
        def self.find(name)
            @conn = Adauth::AdminConnection.bind
            if group = @conn.search(:filter => Net::LDAP::Filter.eq('name', name)).first
                return self.new(group)
            else
                return nil
            end
        end
        
        # Returns the members of the group
        #
        # Called as:
        #    Adauth::Group.members
        #
        # Returns an array of Adauth::Users for the group
        def members
            filters = Net::LDAP::Filter.eq("memberof","CN=#{name},#{dn}")
            members_ldap = @conn.search(:filter => filters)
            members = []
            members_ldap.each do |member|
                user = Adauth::User.create_from_login(member.samaccountname.first)
                members.push(user)
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