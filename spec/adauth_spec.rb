require 'lib/adauth'
require 'yaml'

describe Adauth, "#configure" do
    it "should accept a block" do
        Adauth.configure do |c|
            c.domain = "example.com"
        end
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

describe Adauth, "#authenticate" do
    before :each do
        @yaml = YAML::load(File.open('spec/test_data.yml'))
        Adauth.configure do |c|
            c.domain = @yaml["domain"]["domain"]
            c.server = @yaml["domain"]["server"]
            c.port = @yaml["domain"]["port"]
            c.base = @yaml["domain"]["base"]
        end
    end
    
    it "should succesfully authenticate with the example user" do
        Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"]).should be_a Adauth::User
    end
    
    it "should return nil for a failed bind" do
        Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["group"]).should == nil
    end
    
    it "should return nil for a failed bind whilst using allowed groups" do
       Adauth.config.allowed_groups = @yaml["domain"]["pass_allowed_groups"]
       Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["group"]).should be_nil
    end
    
    it "should allow users who are in an allowed group" do
       Adauth.config.allowed_groups = @yaml["domain"]["pass_allowed_groups"]
       Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"]).should be_a Adauth::User
    end
    
    it "should dis-allow users who are not in an allowed group" do
       Adauth.config.allowed_groups = @yaml["domain"]["fail_allowed_groups"]
       Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"]).should be_nil
    end
    
    it "should dis-allow users who are in a denied group" do
        Adauth.config.denied_groups = @yaml["domain"]["pass_allowed_groups"]
        Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"]).should be_nil
    end
    
    it "should dis-allow users who are in a denied group" do
        Adauth.config.denied_groups = @yaml["domain"]["fail_allowed_groups"]
        Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"]).should be_a Adauth::User
    end
end

describe Adauth::User do
    before :each do
        @yaml = YAML::load(File.open('spec/test_data.yml'))
        Adauth.configure do |c|
            c.domain = @yaml["domain"]["domain"]
            c.server = @yaml["domain"]["server"]
            c.port = @yaml["domain"]["port"]
            c.base = @yaml["domain"]["base"]
        end
        @user = Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"])
    end
    
    it "should return groups for an authenticated user" do
        @user.groups.should be_a Array
    end
    
    it "should return true for a member_of test using the users group" do
        @user.member_of?(@yaml["user"]["group"]).should == true
    end
    
    it "should return false for a member_of test using the users password" do
        @user.member_of?(@yaml["user"]["password"]).should == false
    end
    
    it "should have the correct user" do
        @user.login.should == @yaml["user"]["login"]
    end
end