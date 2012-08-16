require 'spec_helper'

describe Adauth::AdObjects::OU do
    it "should find Domain Controllers" do
        default_config
        domain_controllers.should be_a Adauth::AdObjects::OU
    end
    
    it "should have members" do
        default_config
        domain_controllers.members.should be_a Array
    end
    
    it "should have a computer as a member" do
        default_config
        domain_controllers.members.first.should be_a Adauth::AdObjects::Computer
    end
end