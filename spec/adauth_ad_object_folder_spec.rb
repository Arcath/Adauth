require 'spec_helper'

describe Adauth::AdObjects::Folder do
    it "should find Domain Controllers" do
        default_config
        Adauth::AdObjects::Folder.root.should be_a Adauth::AdObjects::Folder
    end
    
    it "should have members" do
        default_config
        Adauth::AdObjects::Folder.root.members.should be_a Array
    end
end