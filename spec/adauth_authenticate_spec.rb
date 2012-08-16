require 'spec_helper'

describe Adauth, "#authenticate" do
    it "should return a user for authentication" do
        default_config
        Adauth.authenticate(test_data("domain", "query_user"), test_data("domain", "query_password")).should be_a Adauth::AdObjects::User
    end
    
    it "should return false for failed authentication" do
        default_config
        Adauth.authenticate(test_data("domain", "query_user"), "foo").should be_false
    end
    
    it "should reject a user if denied group is used" do
        Adauth.configure do |c|
            c.domain = test_data("domain", "domain")
            c.port = test_data("domain", "port")
            c.base = test_data("domain", "base")
            c.server = test_data("domain", "server")
            c.query_user = test_data("domain", "query_user")
            c.query_password = test_data("domain", "query_password")
            c.denied_groups = ["Administrators"]
        end
        Adauth.authenticate(test_data("domain", "query_user"), test_data("domain", "query_password")).should be_false
    end
    
    it "should reject a user if denied ous is used" do
        Adauth.configure do |c|
            c.domain = test_data("domain", "domain")
            c.port = test_data("domain", "port")
            c.base = test_data("domain", "base")
            c.server = test_data("domain", "server")
            c.query_user = test_data("domain", "query_user")
            c.query_password = test_data("domain", "query_password")
            c.denied_ous = ["Users"]
        end
        Adauth.authenticate(test_data("domain", "query_user"), test_data("domain", "query_password")).should be_false
    end
end