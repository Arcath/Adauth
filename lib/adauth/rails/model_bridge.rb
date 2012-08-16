module Adauth
    module Rails
        # Included into Models in Rails
        #
        # Requires you to set 2 Constants
        #
        # AdauthMappings
        #
        # A hash which controls how Adauth maps its values to rails e.g.
        #
        # AdauthMappings = {
        #   :name => :login
        # }
        #
        # This will store Adauths 'login' value in the 'name' field.
        #
        # AdauthSearchField
        #
        # This is an array which contains 2 values and is used to find the objects record e.g.
        #
        # AdauthSearchField = [:login, :name]
        #
        # This will cause RailsModel.find_by_name(AdauthObject.login)
        #
        # The Order is [adauth_field, rails_field]
        module ModelBridge
            # Registers the class methods when ModelBridge is included
            def self.included(base)
                base.extend ClassMethods
            end
            
            # Uses AdauthMappings to update the values on the model using the ones from Adauth
            def update_from_adauth(adauth_model)
                self.class::AdauthMappings.each do |k, v|
                    setter = "#{k.to_s}=".to_sym
                    self.send(setter, adauth_model.send(v))
                end
                self.save
            end
            
            # Class Methods for ModelBridge
            module ClassMethods
                # Creates a new RailsModel from the adauth_model
                def create_from_adauth(adauth_model)
                    rails_model = self.new
                    rails_model.update_from_adauth(adauth_model)
                end
                
                # Used to create the RailsModel if it doesn't exist and update it if it does
                def return_and_create_from_adauth(adauth_model)
                    find_method = "find_by_#{self::AdauthSearchField.last}".to_sym
                    rails_model = (self.send(find_method, adauth_model.send(self::AdauthSearchField.first)) || create_from_adauth(adauth_model))
                    rails_model.update_from_adauth(adauth_model)
                    return rails_model
                end
            end
        end
    end
end