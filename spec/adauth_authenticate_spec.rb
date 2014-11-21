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

    it "should return false for a user that does not exist" do
      default_config
      Adauth.authenticate("foo", "bar").should be_false
    end

    it "should allow the user if allowed groups are used" do
      Adauth.configure do |c|
          c.domain = test_data("domain", "domain")
          c.port = test_data("domain", "port")
          c.base = test_data("domain", "base")
          c.server = test_data("domain", "server")
          c.query_user = test_data("domain", "query_user")
          c.query_password = test_data("domain", "query_password")
          c.allowed_groups = ["Administrators"]
      end
      Adauth.authenticate(test_data("domain", "query_user"), test_data("domain", "query_password")).should be_a Adauth::AdObjects::User
    end

    it "should allow the user if allowed ous are used" do
      Adauth.configure do |c|
          c.domain = test_data("domain", "domain")
          c.port = test_data("domain", "port")
          c.base = test_data("domain", "base")
          c.server = test_data("domain", "server")
          c.query_user = test_data("domain", "query_user")
          c.query_password = test_data("domain", "query_password")
          c.allowed_ous = ["Users"]
      end
      Adauth.authenticate(test_data("domain", "query_user"), test_data("domain", "query_password")).should be_a Adauth::AdObjects::User
    end

    it "should reject a user not in an allowed ou" do
      Adauth.configure do |c|
          c.domain = test_data("domain", "domain")
          c.port = test_data("domain", "port")
          c.base = test_data("domain", "base")
          c.server = test_data("domain", "server")
          c.query_user = test_data("domain", "query_user")
          c.query_password = test_data("domain", "query_password")
          c.allowed_ous = ["Users2"]
      end
      Adauth.authenticate(test_data("domain", "query_user"), test_data("domain", "query_password")).should be_false
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

    it "should allow for simple authentication" do
      Adauth.configure do |c|
          c.domain = test_data("domain", "domain")
          c.port = test_data("domain", "port")
          c.base = test_data("domain", "base")
          c.server = test_data("domain", "server")
      end

      Adauth.simple_authenticate(test_data("domain", "query_user"), test_data("domain", "query_password")).should be_true
    end

    it "should allow for simple authentication to return false" do
      Adauth.configure do |c|
          c.domain = test_data("domain", "domain")
          c.port = test_data("domain", "port")
          c.base = test_data("domain", "base")
          c.server = test_data("domain", "server")
      end

      Adauth.simple_authenticate(test_data("domain", "query_user"), 'not the password').should be_false
    end
end
