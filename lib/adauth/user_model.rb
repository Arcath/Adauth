module Adauth
    module UserModel
        def self.included(base)
            base.extend ClassMethods
        end
        
    	def groups
    	   group_strings.split(", ") 
	    end
	    
	    module ClassMethods
	        def return_and_create_with_adauth(adauth_user)
                find_by_login(adauth_user.login) || create_user_with_adauth(adauth_user)
            end

            def create_user_with_adauth(adauth_user)
        		create! do |user|
        			user.login = adauth_user.login
        			user.group_strings = adauth_user.groups.join(", ")
        			user.name = adauth_user.name
        		end
        	end 
        end
    end
end