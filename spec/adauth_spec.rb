require 'spec_helper'

describe Adauth, :no_ad => true do
    it "should accept a block" do
        Adauth.configure do |c|
        end
    end
  
    it "should be able to have a new logged defined" do
      Adauth.logger= Logger.new('log/newlogger.log', 'daily')
    end
end