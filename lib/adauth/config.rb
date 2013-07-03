module Adauth
    # Holds all of Adauths Config values.
    #
    # Sets the defaults an create and generates guess values.
    class Config
        attr_accessor   :domain, :port, :base, :server, :encryption, :query_user, :query_password, :allow_fallback,
                        :allowed_groups, :denied_groups, :allowed_ous, :denied_ous, :contains_nested_groups
        
        def initialize
            @port = 389
            @allowed_groups = []
            @allowed_ous = []
            @denied_groups =[]
            @denied_ous = []
            @allow_fallback = false
            @contains_nested_groups = false
        end
        
        # Guesses the Server and Base string
        def domain=(s)
            @domain = s
            @server ||= s
            @base ||= s.gsub(/\./,', dc=').insert(0, 'dc=')
        end
    end
end