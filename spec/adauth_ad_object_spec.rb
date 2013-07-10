require 'spec_helper'

describe Adauth::AdObject do
  it "should still have method missing" do
    pdc.should be_a Adauth::AdObjects::Computer
    lambda { pdc.foo_bar }.should raise_exception NoMethodError
  end
  
  it "should generate a nested group list" do
    breakable_user.cn_groups.should_not eq breakable_user.cn_groups_nested
  end
  
  it "should get the correct number of groups" do
    query_user.cn_groups.count.should eq test_data("domain", "query_user_membership_count")
  end
end