module Adauth
    module Helpers
        def adauth_form
        	form_tag '/adauth', :id => "adauth_login" do
        	    yield.html_safe
    	    end
        end
        
        def default_adauth_form
            adauth_form do
                "<p>#{label_tag :username}: 
                #{text_field_tag :username}</p>
                <p>#{label_tag :password}: 
                #{password_field_tag :password}</p>
                <p>#{submit_tag "Login!"}</p>"
            end
        end
    end
end

ActionView::Base.send :include, Adauth::Helpers if defined? ActionView