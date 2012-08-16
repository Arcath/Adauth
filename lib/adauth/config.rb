module Adauth
    class Config
        attr_accessor   :domain, :port, :base, :server, :encryption, :query_user, :query_password,
                        :allowed_groups, :denied_groups, :allowed_ous, :denied_ous
        
        def initialize
            @port = 389
            @allowed_groups = []
            @allowed_ous = []
            @denied_groups =[]
            @denied_ous = []
        end
        
        def domain=(s)
            @domain = s
            @server ||= s
            @base ||= s.gsub(/\./,', dc=').gsub(/^/,"dc=")
        end
    end
end