require 'lib/adauth'
require 'yaml'

describe Adauth::Group do
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
    
    it "should return an instance of Adauth::Group if the group exists" do
        group = Adauth::Group.find(@yaml["user"]["group"])
        group.should be_a Adauth::Group
        group.name.should eq(@yaml["user"]["group"])
    end 
    
    it "should return nil for a group that doesn't exist" do
        Adauth::Group.find(@yaml["user"]["group"][0..2]).should be_nil
    end
    
    it "should return an array from group.members" do
        group = Adauth::Group.find(@yaml["user"]["group"])
        group.members.should be_a Array
        group.members.count.should_not eq(0)
    end
    
    it "should return an array of adauth::users from group.members" do
        group = Adauth::Group.find(@yaml["user"]["group"])
        group.members.each do |member|
            member.should be_a Adauth::User
        end
    end
    
    it "should only return users in this groups" do
        group = Adauth::Group.find(@yaml["user"]["group"])
        group.members.each do |member|
            member.groups.include?(@yaml["user"]["group"]).should be_true
        end
    end
    
    it "should return an array of ous" do
        group = Adauth::Group.find(@yaml["user"]["group"])
        group.ous.should be_a Array
    end
end