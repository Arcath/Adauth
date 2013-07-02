require 'spec_helper'

describe Adauth::AdObject do
  it "should still have method missing" do
    pdc.should be_a Adauth::AdObjects::Computer
    lambda { pdc.foo_bar }.should raise_exception NoMethodError
  end
end