module Adauth
    module Generators
        
        # Generates a sample config file
        class ConfigGenerator < ::Rails::Generators::Base
            source_root File.expand_path('../templates', __FILE__)
            
            # Generates a sample config file
            #
            # Called by running:
            #    rails g adauth:config
            def generate_config
                template "config.rb.erb", "config/initializers/adauth.rb"
            end
        end
    end
end