module Adauth

    # Holds all of adauth config in attr_accessor values
    class Config
        attr_accessor   :domain, :port, :base, :server, :allowed_groups, :denied_groups, :ad_sv_attrs, :ad_mv_attrs, :allowed_ous, :denied_ous,
                        :admin_user, :admin_password, :ad_sv_group_attrs, :ad_mv_group_attrs, :encryption

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
           @ad_sv_group_attrs = {}
           @ad_mv_group_attrs = {}
        end

        # Sets domain valiable
        #
        # Called as:
        #    Adauth::Config.domain=(s)
        #
        # Calculates both base string and server
        def domain=(s)
            @domain = s
            work_out_base(s)
            @server ||= s
        end

        private

        def work_out_base(s)
            @base ||= s.gsub(/\./,', dc=').gsub(/^/,"dc=")
        end
    end
end
