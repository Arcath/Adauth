module Adauth
    # Container for Objects which inherit from Adauth::AdObject
    module AdObjects
    end
  
    def self.add_field(object, adauth_method, ldap_method)
        object::Fields[adauth_method] = ldap_method
    end
    
    # Active Directory Interface Object
    #
    # Objects inherit from this class.
    #
    # Provides all the common functions for Active Directory.
    class AdObject      
        # Returns all objects which have the ObjectClass of the inherited class
        def self.all
            self.filter(self::ObjectFilter)
        end
        
        # Returns all the objects which match the supplied query
        #
        # Uses ObjectFilter to restrict to the current object
        def self.where(field, value)
            search_filter = Net::LDAP::Filter.eq(field, value)
            filter(add_object_filter(search_filter))
        end
        
        # Returns all LDAP objects that match the given filter
        #
        # Use with add_object_filter to make sure that you only get objects that match the object you are querying though
        def self.filter(filter)
          results = []

          result = Adauth.connection.search(:filter => filter)

          raise 'Search returned NIL' if result == nil

          result.each do |entry|
            results << self.new(entry)
          end

          results
        end
        
        # Adds the object filter to the passed filter
        def self.add_object_filter(filter)
          filter & self::ObjectFilter
        end
        
        # Creates a new instance of the object and sets @ldap_object to the passed Net::LDAP entity        
        def initialize(ldap_object)
            @ldap_object = ldap_object
        end
        
        # Allows direct access to @ldap_object 
        def ldap_object
            @ldap_object
        end
        
        # Over rides method_missing and interacts with @ldap_object
        def method_missing(method, *args)
            if self.class::Fields.keys.include?(method)
                field = self.class::Fields[method]
                if field.is_a? Symbol
                    return (@ldap_object.send(field).to_s).gsub(/\"|\[|\]/, "")
                elsif field.is_a? Array
                    @ldap_object.send(field.first).collect(&field.last)
                end
            else
                super
            end
        end
        
        # Returns all the groups the object is a member of
        def groups
            unless @groups
                @groups = convert_to_objects(cn_groups)
            end
            @groups
        end
        
        # Returns all the ous the object is in
        def ous
            unless @ous
                @ous = []
                @ldap_object.dn.split(/,/).each do |entry|
                    @ous.push Adauth::AdObjects::OU.where('name', entry.gsub(/OU=/, '')).first if entry =~ /OU=/
                end
            end
            @ous
        end
        
        # CSV Version of the ous list (can't be pulled over from AD)
        def dn_ous
            unless @dn_ous
                @dn_ous = []
                @ldap_object.dn.split(/,/).each do |entry|
                    @dn_ous.push entry.gsub(/OU=/, '').gsub(/CN=/,'') if entry =~ /OU=/ or entry == "CN=Users"
                end
            end
            @dn_ous
        end
        
        def modify(operations)
            raise 'Modify Operation Failed' unless Adauth.connection.modify :dn => @ldap_object.dn, :operations => operations
        end
        
        def members
            unless @members
                @members = []
                [Adauth::AdObjects::Computer, Adauth::AdObjects::OU, Adauth::AdObjects::User, Adauth::AdObjects::Group].each do |object|
                    object.all.each do |entity|
                        @members.push entity if entity.is_a_member?(self)
                    end
                end
            end
            @members
        end
        
        def is_a_member?(parent)
          my_split_dn = @ldap_object.dn.split(",")
          parent_split_dn = parent.ldap_object.dn.split(",")
          if (my_split_dn.count - 1) == parent_split_dn.count
            return true if my_split_dn[1] == parent_split_dn[0]
          end
          return false
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