module Adauth
    class AdObject
        def self.all
            results = []
            Adauth.connection.search(:filter => self::ObjectFilter).each do |result|
                results.push self.new(result)
            end
            results
        end
        
        def self.where(field, value)
            results = []
            search_filter = Net::LDAP::Filter.eq(field, value)
            joined_filter = search_filter & self::ObjectFilter
            Adauth.connection.search(:filter => joined_filter).each do |result|
                results.push self.new(result)
            end
            results
        end
        
        def self.where_dn_ends(value)
            results = []
            search_filter = Net::LDAP::Filter.ends('dn', value)
            joined_filter = search_filter & self::ObjectFilter
            Adauth.connection.search(:filter => joined_filter).each do |result|
                results.push self.new(result)
            end
            results
        end
        
        def initialize(ldap_object)
            @ldap_object = ldap_object
        end
        
        def ldap_object
            @ldap_object
        end
        
        def method_missing(method, *args)
            if self.class::Fields.keys.include?(method)
                field = self.class::Fields[method]
                if field.is_a? Symbol
                    return @ldap_object.send(field).to_s
                elsif field.is_a? Array
                    @ldap_object.send(field.first).collect(&field.last)
                end
            else
                super
            end
        end
        
        def groups
            unless @groups
                @groups = convert_to_objects(cn_groups)
            end
            @groups
        end
        
        def ous
            unless @ous
                @ous = []
                @ldap_object.dn.split(/,/).each do |entry|
                    @ous.push Adauth::AdObjects::OU.where('name', entry.gsub(/OU=/, '')).first if entry =~ /OU=/
                end
            end
            @ous
        end
        
        private
        
        def convert_to_objects(array)
            out = []
            array.each do |entity|
                out.push convert_to_object(entity)
            end
            out
        end
        
        def convert_to_object(entity)
            user = Adauth::AdObjects::User.where('sAMAccountName', entity).first
            group = Adauth::AdObjects::Group.where('sAMAccountName', entity).first
            (user || group)
        end
    end
end