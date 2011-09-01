require 'lib/adauth'
require 'yaml'

ReturnDataForTest = []

class TestModel
    include Adauth::UserModel
    
    attr_accessor :login, :group_strings, :name, :ou_strings
    
    def self.create!
        @user = self.new
        yield(@user)
        return @user
    end
    
    def self.find_by_login(login)
        ReturnDataForTest.last
    end
    
    def save
        true
    end
end

describe TestModel, "creations" do
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
    
    it "should create a new user for method `create_user_with_adauth`" do
        TestModel.create_user_with_adauth(@user).should be_a TestModel
    end
    
    it "should return a user for method `return_and_create_with_adauth`, if no user exists in the db" do
        ReturnDataForTest.push nil
        TestModel.return_and_create_with_adauth(@user).should be_a TestModel
    end
    
    it "should return a user for method `return_and_create_with_adauth`, if the user does exist" do
        ReturnDataForTest.push TestModel.create_user_with_adauth(@user)
        TestModel.return_and_create_with_adauth(@user).should be_a TestModel
    end
end

describe TestModel, "methods" do
    before :each do
        @yaml = YAML::load(File.open('spec/test_data.yml'))
        Adauth.configure do |c|
            c.domain = @yaml["domain"]["domain"]
            c.server = @yaml["domain"]["server"]
            c.port = @yaml["domain"]["port"]
            c.base = @yaml["domain"]["base"]
        end
        @user = Adauth.authenticate(@yaml["user"]["login"], @yaml["user"]["password"])
        @model = TestModel.create_user_with_adauth(@user)
    end
    
    it "should return an array of groups for .groups" do
        @model.groups.should be_a Array
    end
    
    it "should return an array of ous for .ous" do
        @model.ous.should be_a Array
    end
    
    it "should update from adauth" do
        @model.name = "Adauth Testing user that should be different"
        @model.name.should_not eq(@user.name)
        @model.update_from_adauth(@user)
        @model.name.should eq(@user.name)
    end
end