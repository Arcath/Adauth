require 'lib/adauth'
require 'yaml'

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
    
    it "should allow users who are in a denied group" do
        Adauth.config.denied_groups = @yaml["domain"]["fail_allowed_groups"]
        Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"]).should be_a Adauth::User
    end
    
    it "should allow users who are in an allowed ou" do
        Adauth.config.allowed_ous = @yaml["domain"]["pass_allowed_ous"]
        Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"]).should be_a Adauth::User
    end
    
    it "should dis-allow users who are not in an allowed ou" do
        Adauth.config.allowed_ous = @yaml["domain"]["fail_allowed_ous"]
        Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"]).should be_nil
    end
    
    it "should dis-allow users who are in a denied ou" do
        Adauth.config.denied_ous = @yaml["domain"]["pass_allowed_ous"]
        Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"]).should be_nil
    end
    
    it "should allow users who are not in a denied ou" do
        Adauth.config.denied_ous = @yaml["domain"]["fail_allowed_ous"]
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
    
    it "should return ous for an authenticated user" do
        @user.ous.should be_a Array
    end

    it "should have all the ous from the data file" do
        @yaml["user"]["ous"].each do |ou|
            @user.ous.include?(ou).should be_true
        end
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

describe "Adauth::User custom returns" do
    before :each do
        @yaml = YAML::load(File.open('spec/test_data.yml'))
        Adauth.configure do |c|
            c.domain = @yaml["domain"]["domain"]
            c.server = @yaml["domain"]["server"]
            c.port = @yaml["domain"]["port"]
            c.base = @yaml["domain"]["base"]
            c.ad_sv_attrs = { :phone => :telephonenumber }
            c.ad_mv_attrs = { :ous => [ :memberof,
                                            Proc.new {|g| g.sub(/.*?OU=(.*?),.*/, '\1')} ] }
        end    
        @user = Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"])
    end
    
    it "should pickup the custom single value from AD" do
        @user.phone.should be_a String
    end
    
    it "should pickup the custom multi value from AD" do
        @user.ous.should be_a Array
    end
end

describe Adauth::AdminConnection do
    before :each do
        @yaml = YAML::load(File.open('spec/test_data.yml'))
        Adauth.configure do |c|
            c.domain = @yaml["domain"]["domain"]
            c.server = @yaml["domain"]["server"]
            c.port = @yaml["domain"]["port"]
            c.base = @yaml["domain"]["base"]
            c.admin_user = @yaml["domain"]["admin_user"]
            c.admin_password = @yaml["domain"]["admin_password"]
        end
    end
    
    it "should create a connection" do
        Adauth::AdminConnection.bind.should be_a Net::LDAP
    end
    
    it "should raise an exception if the password is wrong" do
        Adauth.config.admin_password = @yaml["domain"]["admin_password"][1]
        lambda { Adauth::AdminConnection.bind }.should raise_error
    end
end