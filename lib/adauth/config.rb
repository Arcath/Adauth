module Adauth
    class Config
        attr_accessor :domain, :port, :base, :server
        
        def initialize
           @port = 389 
        end
    end
end