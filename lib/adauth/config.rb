module Adauth
    class Config
        attr_accessor :domain, :port, :base, :server, :encryption, :query_user, :query_password
        
        def initialize
            @port = 389
        end
        
        def domain=(s)
            @domain = s
            @server ||= s
            @base ||= s.gsub(/\./,', dc=').gsub(/^/,"dc=")
        end
    end
end