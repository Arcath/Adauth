require 'spec_helper'

describe Adauth::AdObjects::Computer do
    it "Should find a computer" do
        default_config
        pdc.should be_a Adauth::AdObjects::Computer
    end
    
    it "should only find computers" do
      default_config
      Adauth::AdObjects::Computer.all.each do |computer|
        computer.should be_a Adauth::AdObjects::Computer
      end
    end
    
    it "should be in an ou" do
        default_config
        pdc.ous.should be_a Array
        pdc.ous.first.should be_a Adauth::AdObjects::OU
        pdc.ous.first.name.should eq "Domain Controllers"
    end
end