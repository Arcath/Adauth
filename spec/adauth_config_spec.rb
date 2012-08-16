require 'spec_helper'

describe Adauth::Config, :no_ad => true do
    it "should default port to 389" do
        config = Adauth::Config.new
        config.port.should eq 389
    end
    
    it "should calculate the default settings" do
        config = Adauth::Config.new
        config.domain = "example.com"
        config.base.should eq "dc=example, dc=com"
        config.server.should eq "example.com"
    end
end