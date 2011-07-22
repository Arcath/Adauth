module Adauth
    module Generators
        class AllGenerator < Rails::Generators::Base
            def all_generators
                generate "adauth:config"
                generate "adauth:user_model"
                generate "adauth:sessions"
            end
        end
    end
end