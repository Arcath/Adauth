require 'spec_helper'

class TestUserModel
    include Adauth::Rails::ModelBridge
    
    attr_accessor :name
    
    AdauthMappings = {
        :name => :name
    }
    
    AdauthSearchField = [:name]
    
    def self.find_by_name(name)
        TestUserModel.new
    end
    
    def save
        return true
    end
end

describe Adauth::Rails::ModelBridge do
      it "should extend", :no_ad => true do
        TestUserModel.should respond_to :create_from_adauth
    end
    
    it "should create the model" do
        default_config
        TestUserModel.create_from_adauth(administrator)
    end
    
    it "should return and create the model" do
        default_config
        TestUserModel.return_and_create_from_adauth(administrator)
    end
end
