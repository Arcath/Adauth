require 'lib/adauth'
require 'yaml'

describe Adauth, "#configure" do
    it "should accept a block" do
        Adauth.configure do |c|
            c.domain = "test.example.com"
        end
    end
    
    it "should correctly calculate the base" do
        Adauth.config.base.should eq("dc=test, dc=example, dc=com")
    end
    
    it "should set the server to the domain if not specified" do
        Adauth.config.server.should eq("test.example.com")
    end
end

describe Adauth, "#config" do
    before :each do
        Adauth.configure do |c|
            c.domain = "example.com"
            c.base = "dc=example, dc=com"
            c.server = "127.0.0.1"
        end
    end
    
    it "should allow retrival of data" do
        Adauth.config.domain.should == "example.com"
    end
    
    it "should set port to 389 if not set" do
        Adauth.config.port.should == 389
    end
end