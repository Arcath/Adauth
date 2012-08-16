require 'spec_helper'

describe Adauth::AdObjects::Group do
    it "should have a name" do
        default_config
        group = domain_admins
        group.name.should eq "Domain Admins"
    end
    
    it "should have a members list" do
        default_config
        group = domain_admins
        group.members.first.name.should be_a String
    end
    
    it "should be a member of" do
        default_config
        group = domain_admins
        group.groups.should be_a Array
    end
end