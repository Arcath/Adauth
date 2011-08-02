module Adauth
    
    # Holds all of adauth config in attr_accessor values
    class Config
        attr_accessor :domain, :port, :base, :server, :allowed_groups, :denied_groups, :ad_sv_attrs, :ad_mv_attrs, :allowed_ous, :denied_ous
        
        # Creates a new instance of Adauth::Config
        #
        # Sets port, allowed_groups, denied_groups, ad_sv_attrs and ad_mv_attrs to default so they can be omitted from the config
        def initialize
           @port = 389
           @allowed_groups = []
           @denied_groups = []
           @ad_sv_attrs = {}
           @ad_mv_attrs = {}
           @allowed_ous = []
           @denied_ous = []
        end
        
        def domain=(s)
            @domain = s
            work_out_base(s)
        end
        
        private
        
        def work_out_base(s)
            dcs = []
            s.split(/\./).each do |split|
                dcs.push("dc=#{split}")
            end
            @base ||= dcs.join(', ')
        end
    end
end