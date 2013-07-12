require 'spec_helper'

describe Adauth::AdObjects::User do
    let(:user) do
      Adauth::AdObjects::User.where('sAMAccountName', test_data("domain", "breakable_user")).first
    end
    
    it "should find administrator" do
        default_config
        user.login.should eq test_data("domain", "breakable_user")
    end
    
    it "should authenticate a user" do
        default_config
        Adauth::AdObjects::User.authenticate(test_data("domain", "query_user"), test_data("domain", "query_password")).should be_true
    end
    
    it "should find groups" do
        default_config
        user.groups.should be_a Array
        user.groups.first.should be_a Adauth::AdObjects::Group
    end
    
    it "should return boolean for member_of" do
        default_config
        user.member_of?("A Group").should be_false
    end
    
    it "should allow for modification" do
        default_config
        Adauth.add_field(Adauth::AdObjects::User, :phone, :homePhone)
        number = user.phone
        user.modify([[:replace, :homephone, "8765"]])
        new_user = Adauth::AdObjects::User.where('sAMAccountName', test_data("domain", "breakable_user")).first
        new_user.phone.should eq "8765"
        new_user.modify([[:replace, :homephone, number]])
        new2_user = Adauth::AdObjects::User.where('sAMAccountName', test_data("domain", "breakable_user")).first
        new2_user.phone.should eq number
    end
    
    it "should allow for additional methods" do
        default_config
        Adauth.add_field(Adauth::AdObjects::User, :description, :description)
        administrator.description.should be_a String
        Adauth.add_field(Adauth::AdObjects::User, :objectguid, :objectguid)
        administrator.objectguid.should be_a String
    end
    
    it "should allow you to reset the password" do
      default_config
      begin
        Adauth::AdObjects::User.authenticate(test_data("domain", "breakable_user"), test_data("domain", "breakable_password")).should be_true
        user = Adauth::AdObjects::User.where('sAMAccountName', test_data("domain", "breakable_user")).first
        user.login.should eq test_data("domain", "breakable_user")
        user.set_password("adauth_test")
        Adauth::AdObjects::User.authenticate(test_data("domain", "breakable_user"), "adauth_test").should be_true
        user.set_password(test_data("domain", "breakable_password"))
        Adauth::AdObjects::User.authenticate(test_data("domain", "breakable_user"), test_data("domain", "breakable_password")).should be_true
      rescue RuntimeError
        pending("Insecure connection, unable to test change password")
      end
    end
end