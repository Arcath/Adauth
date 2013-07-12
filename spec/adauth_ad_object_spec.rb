require 'spec_helper'

describe Adauth::AdObject do
  let(:computer) do
    ou = Adauth::AdObjects::OU.where('name', 'Domain Controllers').first
    ou.members.first
  end
  
  let(:user) do
    Adauth::AdObjects::User.where('sAMAccountName', test_data("domain", "breakable_user")).first
  end
  
  it "should still have method missing" do
    default_config
    computer.should be_a Adauth::AdObjects::Computer
    lambda { computer.foo_bar }.should raise_exception NoMethodError
  end
  
  it "should generate a nested group list" do
    user.cn_groups.should_not eq user.cn_groups_nested
  end
end