require 'spec_helper'

describe Adauth do
    it "should accept a block" do
        Adauth.configure do |c|
        end
    end
end