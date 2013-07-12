require 'spec_helper'

describe Adauth::AdObjects::Group do
    let(:domain_admins) do
      Adauth::AdObjects::Group.where('name', 'Domain Admins').first
    end
    
    it "should have a name" do
        default_config
        domain_admins.name.should eq "Domain Admins"
    end
    
    it "should have a members list" do
        default_config
        domain_admins.members.should be_a Array
        domain_admins.members.first.name.should be_a String
    end
    
    it "should be a member of" do
        default_config
        domain_admins.groups.should be_a Array
    end
end