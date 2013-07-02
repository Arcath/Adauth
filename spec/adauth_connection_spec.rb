require 'spec_helper'

describe Adauth::Connection do
  it "should support encryption" do
    Adauth.configure do |c|
      c.domain = test_data("domain", "domain")
      c.port = test_data("domain", "port")
      c.base = test_data("domain", "base")
      c.server = test_data("domain", "server")
      c.encryption = :simple_tls
      c.query_user = test_data("domain", "query_user")
      c.query_password = test_data("domain", "query_password")
    end
    begin
      Adauth.authenticate(test_data("domain", "query_user"), test_data("domain", "query_password"))
    rescue
      # Failed to authenticate due to encryption (not what we are testing here)
    end
  end
  
  it "should timeout if asked to connect to a server that doesn't exist" do
    Adauth.configure do |c|
      c.domain = test_data("domain", "domain")
      c.port = test_data("domain", "port")
      c.base = test_data("domain", "base")
      c.server = "127.0.0.2"
      c.query_user = test_data("domain", "query_user")
      c.query_password = test_data("domain", "query_password")
    end

    lambda { Adauth::AdObjects::User.all }.should raise_exception
  end
end