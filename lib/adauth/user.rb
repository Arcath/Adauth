module Adauth
    class User
        ATTR_SV = {
              :login => :samaccountname,
              :first_name => :givenname,
              :last_name => :sn,
              :email => :mail,
              :name => :name
        }
            
        ATTR_MV = {
              :groups => [ :memberof,
                           Proc.new {|g| g.sub(/.*?CN=(.*?),.*/, '\1')} ]
        }

        def self.authenticate(login, pass)
            return nil if login.empty? or pass.empty?
            conn = Net::LDAP.new    :host => Adauth.config.server,
                                    :port => Adauth.config.port,
                                    :base => Adauth.config.base,
                                    :auth => { :username => "#{login}@#{Adauth.config.domain}",
                                        :password => pass,
                                        :method => :simple }
            if conn.bind and user = conn.search(:filter => "sAMAccountName=#{login}").first
                return self.new(user)
            else
                return nil
            end
        rescue Net::LDAP::LdapError => e
            return nil
        end

        def full_name
            self.first_name + ' ' + self.last_name
        end

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
            ATTR_SV.each_pair do |k, v|
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
            ATTR_MV.each_pair do |k, v|
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