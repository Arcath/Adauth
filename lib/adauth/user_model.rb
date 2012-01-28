module Adauth
    
    # Module desgined to be included in a ActiveRecord user model
    module UserModel
        
        # Adds class methods to the ActiveRecord model when included
        def self.included(base)
            base.extend ClassMethods
        end
        
        # Returns an array of groups for the user
        #
        # Called as:
        #    UserInstance.groups
        #
        # The array is generated from the group_strings attribute which is set by the adauth update and create methods. This array will match the windows security groups the user is a member of.
    	def groups
    	   group_strings.split(", ") 
	    end
	    
	    # Returns an array of groups for the user
        #
        # Called as:
        #    UserInstance.ous
        #
        # The array is generated from the group_strings attribute which is set by the adauth update and create methods. This array will match the orginizational units the user is a member of.
	    def ous
	        ou_strings.split(", ")
        end
	    
	    # Update the user record using an instance of Adauth::User
	    #
	    # Called as:
	    #    UserInstance.update_from_adauth(AdauthUserInstance)
	    #
	    # This method is called on login and shouldn't need to be called at any other time
	    def update_from_adauth(adauth_user)
	        self.group_strings = adauth_user.groups.join(", ")
	        self.name = adauth_user.name.gsub(/\"|\[|\]/, "")
	        self.save
        end
	    
	    # Class methods for the UserModel
	    module ClassMethods
	        
	        # Used during the login process to return the users database record.
	        #
	        # Takes an instance of Adauth::User as an input
	        #
	        # Called as
	        #     YourUserModel.return_and_create_with_adauth(AdauthUserInstance)
	        #
	        # If the user has no user record in the database one will be created. All the details on the record (new and old) will be updated to the lastest details from the AD server
	        def return_and_create_with_adauth(adauth_user)
                user = (find_by_login(adauth_user.login.gsub(/\"|\[|\]/, "")) || create_user_with_adauth(adauth_user))
                user.update_from_adauth(adauth_user)
                return user
            end
            
            # Creates a user record from an instance of Adauth::User
            #
            # Called as:
            #    YourUserModel.create_user_with_adauth(AdauthUserInstance)
            #
            # Takes the Adauth::User input and creates a user record with matching details
            def create_user_with_adauth(adauth_user)
        		create! do |user|
        			user.login = adauth_user.login.gsub(/\"|\[|\]/, "")
        			user.group_strings = adauth_user.groups.join(", ")
        			user.ou_strings = adauth_user.ous.join(", ")
        			user.name = adauth_user.name(/\"|\[|\]/, "")
        		end
        	end 
        end
    end
end
