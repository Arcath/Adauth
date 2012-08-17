require 'spec_helper'

describe Adauth::AdObjects::User do
    it "should find administrator" do
        default_config
        user = administrator
        user.login.should eq "Administrator"
    end
    
    it "should authenticate a user" do
        default_config
        Adauth::AdObjects::User.authenticate(test_data("domain", "query_user"), test_data("domain", "query_password")).should be_true
    end
    
    it "should find groups" do
        default_config
        user = administrator
        user.groups.should be_a Array
        user.groups.first.should be_a Adauth::AdObjects::Group
    end
    
    it "should return true for member_of" do
        default_config
        user = administrator
        user.member_of?("Domain Admins").should be_true
    end
    
    it "should allow for modification" do
        default_config
        Adauth.add_field(Adauth::AdObjects::User, :phone, :homePhone)
        number = administrator.phone
        administrator.modify([[:replace, :homephone, "8765"]])
        administrator.phone.should eq "8765"
        administrator.modify([[:replace, :homephone, number]])
    end
    
    it "should allow for additional methods" do
        default_config
        Adauth.add_field(Adauth::AdObjects::User, :description, :description)
        administrator.description.should be_a String
    end
end