require 'spec_helper'

describe "issue #37" do
  it "should not happen" do
    default_config
    ldap_user = Adauth.authenticate("administrator", "foo")
    ldap_user.should be_false
    ldap_user = Adauth.authenticate(test_data("domain", "breakable_user"), "")
    ldap_user.should be_false
    ldap_user = Adauth.authenticate(test_data("domain", "query_user"), test_data("domain", "query_password"))
    ldap_user.should be_a Adauth::AdObjects::User
  end
end
