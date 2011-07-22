module Adauth
    
    # Holds all of adauth config in attr_accessor values
    class Config
        attr_accessor :domain, :port, :base, :server, :allowed_groups, :denied_groups
        
        # Creates a new instance of Adauth::Config
        #
        # Sets port, allowed_groups and denied_groups to default so they can be omitted from the config
        def initialize
           @port = 389
           @allowed_groups = []
           @denied_groups = []
        end
    end
end