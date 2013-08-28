require 'spec_helper'

describe Adauth::AdObjects::Group do
    let(:domain_admins) do
      Adauth::AdObjects::Group.where('name', 'Domain Admins').first
    end
    
    let(:test_ou) do
      Adauth::AdObjects::OU.where('name', test_data("domain", "testable_ou")).first
    end
    
    it "should have a name" do
        default_config
        domain_admins.name.should eq "Domain Admins"
    end
    
    it "should have a members list" do
        default_config
        domain_admins.members.should be_a Array
        domain_admins.members.last.name.should be_a String
    end
    
    it "should be a member of" do
        default_config
        domain_admins.groups.should be_a Array
    end
    
    it "should let you create and destroy a group" do
      default_config
      new_group = Adauth::AdObjects::Group.new_group("Adauth Test Group", test_ou)
      new_group.should be_a Adauth::AdObjects::Group
      new_group.delete
      Adauth::AdObjects::Group.where('name', "Adauth Test Group").count.should eq 0
    end
end