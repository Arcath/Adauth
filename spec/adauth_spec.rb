require 'spec_helper'

describe Adauth, :no_ad => true do
    it "should accept a block" do
        Adauth.configure do |c|
        end
    end
end