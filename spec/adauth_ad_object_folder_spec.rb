require 'spec_helper'

describe Adauth::AdObjects::Folder do
    let(:root_folder) do
      Adauth::AdObjects::Folder.root
    end
  
    it "should find the root of the domain" do
        default_config
        root_folder.should be_a Adauth::AdObjects::Folder
    end
    
    it "should have members" do
        default_config
        root_folder.members.should be_a Array
    end
end