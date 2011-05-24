module Adauth
    class Config
        attr_accessor :domain, :port, :base, :server, :allowed_groups
        
        def initialize
           @port = 389
           @allowed_groups = []
        end
    end
end