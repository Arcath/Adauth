module Adauth
    module Generators
        class SessionsGenerator < Rails::Generators::Base
            source_root File.expand_path('../templates', __FILE__)
            argument :model_name, :type => :string, :default => "user"
            
            def generate_sessions
                template "sessions_controller.rb.erb", "app/controllers/sessions_controller.rb"
                template "new.html.erb", "app/views/sessions/new.html.erb"
                route "resources :sessions"
                route "match \"/adauth\" => \"sessions#create\""
                route "match \"/signout\" => \"sessions#destroy\""
                puts "       extra  Add this code to your ApplicationController"
                puts ""
                puts "              helper_method :current_user"
                puts ""
                puts "              def current_user"
                puts "                  @current_user ||= User.find(session[:user_id]) if session[:user_id]"
                puts "              end"
            end
        end
    end
end
