module Adauth
    
    # The class which links to Active Directory, based on http://metautonomo.us/2008/04/04/simplified-active-directory-authentication/
    #
    # Do no call Adauth::User.new, use Adauth::User.authenticate instead. For all of Adauth additional filtering use Adauth.authenticate.
    class User
        
        # Single vales where the method maps directly to one Active Directory attribute
        ATTR_SV = {
              :login => :samaccountname,
              :first_name => :givenname,
              :last_name => :sn,
              :email => :mail,
              :name => :name
        }
        
        # Multi values where the method needs to return an array for values.
        ATTR_MV = {
              :groups => [ :memberof,
                           Proc.new {|g| g.sub(/.*?CN=(.*?),.*/, '\1')} ],
              :ous => [ :memberof,
                           Proc.new {|g| g.scan(/OU=.*?,/).map { |e| e.sub!(/OU=/,'').sub(/,/,'') } } ]
        }

        # Authenticates a user against Active Directory and returns an instance of self
        #
        # Called as:
        #    Adauth::User.authenticate("username", "password")
        #
        # Usage would by-pass Adauths group filtering.
        def self.authenticate(login, pass)
            return nil if login.empty? or pass.empty?
            conn = Adauth::Connection.bind(login, pass)
            if conn and user = conn.search(:filter => Net::LDAP::Filter.eq('sAMAccountName', login)).first
                return self.new(user)
            else
                return nil
            end
        rescue Net::LDAP::LdapError => e
            return nil
        end

        # Create a Adauth::User object from AD using just the username
        #
        # Called as:
        #    Adauth::User.create_from_login(login)
        #
        # Allows you to create objects for users without using thier password.
        def self.create_from_login(login)
            conn = Adauth::AdminConnection.bind
            user = conn.search(:filter => Net::LDAP::Filter.eq('sAMAccountName', login)).first
            obj = self.new(user)
            return obj
        end

        # Returns the full name of the user
        #
        # Combines the first_name and last_name attributes to create full_name
        def full_name
            self.first_name + ' ' + self.last_name
        end

        # Returns true if the user is a member of the passed group.
        def member_of?(group)
            self.groups.include?(group)
        end

        private

        def initialize(entry)
            @entry = entry
            self.class.class_eval do
                generate_single_value_readers
                generate_multi_value_readers
            end
        end

        def self.generate_single_value_readers
            ATTR_SV.merge(Adauth.config.ad_sv_attrs).each_pair do |k, v|
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
            ATTR_MV.merge(Adauth.config.ad_mv_attrs).each_pair do |k, v|
                val, block = Array(v)
                define_method(k) do
                    if @entry.attribute_names.include?(val)
                        if block.is_a?(Proc)
                            output = @entry.send(val).collect(&block) 
                            output = output.first if output.first.is_a? Array
                            return output
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