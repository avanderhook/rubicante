require File.join(File.expand_path(File.dirname(__FILE__)),"helper")
require "#{LIB_DIR}/website_error" 

describe "An error with a website" do
  before :each do
    @url = "http://www.rubicante-example.com/"
    @code = "500"
    @website_error = Rubicante::WebsiteError.new(@url, @code)
  end

  it "should exist" do
    @website_error.should_not be_nil
    @website_error.should be_an_instance_of(Rubicante::WebsiteError)
  end

  it "should require parameters to be created" do
    lambda { Rubicante::WebsiteError.new }.should raise_error(ArgumentError)
  end

  it "should have a URL" do
    @website_error.url.should == @url
  end

  it "should have an HTTP code" do
    @website_error.code.should == @code
  end

  it "should not allow modification to the URL" do
    lambda { @website_error.url = "http://www.rubyforge-example.org/" }.should raise_error(NoMethodError)
  end

  it "should not allow modification to the HTTP code" do
    lambda { @website_error.code = "301" }.should raise_error(NoMethodError)
  end
end
