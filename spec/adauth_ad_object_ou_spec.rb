require 'spec_helper'

describe Adauth::AdObjects::OU do
    let(:domain_controllers) do
      Adauth::AdObjects::OU.where('name', 'Domain Controllers').first
    end
    
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