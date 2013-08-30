require 'spec_helper'

describe Adauth::SearchResults, :no_ad => true do
  let(:test_array) do
    [OpenStruct.new({name: "foo"}), OpenStruct.new({name: "bar"}), OpenStruct.new({name: "widget"})]
  end
  
  let(:sorted_array) do
    [OpenStruct.new({name: "bar"}), OpenStruct.new({name: "foo"}), OpenStruct.new({name: "widget"})]
  end
  
  let(:search_results) do
    Adauth::SearchResults.new(test_array)
  end
  
  it "should create self from_array" do
    Adauth::SearchResults.new(test_array).should be_a Adauth::SearchResults
  end
  
  it "should have the limit function" do
    search_results.limit(2).length.should eq 2
    search_results.limit(2).last.should_not eq test_array.last
    search_results.limit(2).should be_a Adauth::SearchResults
  end
  
  it "should have the order function" do
    search_results.order(:name, :asc).should eq sorted_array
    search_results.order(:name, :asc).should be_a Adauth::SearchResults
    search_results.order(:name, :desc).should eq sorted_array.reverse
    search_results.order(:name, :desc).should be_a Adauth::SearchResults
  end
  
  it "should handle having a wrong direction passed to it" do
    lambda { search_results.order(:name, :foo) }.should raise_exception
  end
  
  it "should default to :asc for order" do
    search_results.order(:name).should eq sorted_array
    search_results.order(:name).should be_a Adauth::SearchResults
  end
end