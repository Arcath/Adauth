require 'spec_helper'

describe Adauth::AdObjects::Computer do
    let(:computer) do
      ou = Adauth::AdObjects::OU.where('name', 'Domain Controllers').first
      ou.members.first
    end
    
    it "Should find a computer" do
        default_config
        computer.should be_a Adauth::AdObjects::Computer
    end
    
    it "should only find computers" do
      default_config
      Adauth::AdObjects::Computer.all.each do |computer|
        computer.should be_a Adauth::AdObjects::Computer
      end
    end
    
    it "should be in an ou" do
        default_config
        computer.ous.should be_a Array
        computer.ous.first.should be_a Adauth::AdObjects::OU
        computer.ous.first.name.should eq "Domain Controllers"
    end
end