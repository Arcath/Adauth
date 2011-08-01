module Adauth
    
    # Holds all of adauth config in attr_accessor values
    class Config
        attr_accessor :domain, :port, :base, :server, :allowed_groups, :denied_groups, :ad_sv_attrs, :ad_mv_attrs
        
        # Creates a new instance of Adauth::Config
        #
        # Sets port, allowed_groups, denied_groups, ad_sv_attrs and ad_mv_attrs to default so they can be omitted from the config
        def initialize
           @port = 389
           @allowed_groups = []
           @denied_groups = []
           @ad_sv_attrs = {}
           @ad_mv_attrs = {}
        end
    end
end