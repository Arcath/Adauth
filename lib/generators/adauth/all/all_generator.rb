module Adauth
    module Generators
        
        # Runs all of Adauths Generators
        class AllGenerator < Rails::Generators::Base
            
            # Calls all of Adauth Generators
            #
            # Called by running
            #    rails g adauth:all
            def all_generators
                generate "adauth:config"
                generate "adauth:user_model"
                generate "adauth:sessions"
            end
        end
    end
end