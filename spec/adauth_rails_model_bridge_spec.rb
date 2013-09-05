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
  let(:user) do
    Adauth::AdObjects::User.where('sAMAccountName', test_data("domain", "breakable_user")).first
  end
  
      it "should extend", :no_ad => true do
        TestUserModel.should respond_to :create_from_adauth
    end
    
    it "should create the model" do
        default_config
        TestUserModel.create_from_adauth(user)
    end
    
    it "should return and create the model" do
        default_config
        TestUserModel.return_and_create_from_adauth(user)
    end
end
