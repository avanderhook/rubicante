require File.join(File.expand_path(File.dirname(__FILE__)),"helper")
require "#{LIB_DIR}/website" 

describe "A website" do
  before :each do
    @url = 'http://www.rubicante-test.com/'
    @website = Rubicante::Website.new(@url)

    @http_ok           = Net::HTTPOK.new('1', '200', 'OK')
    @http_redirect     = Net::HTTPMovedPermanently.new('1', '301', 'Moved Permanently')
    @http_client_error = Net::HTTPNotFound.new('1', '404', 'File Not Found')
    @http_server_error = Net::HTTPInternalServerError.new('1', '500', 'Internal Server Error')
  end

  it "should exist" do
    @website.should_not be_nil
    @website.should be_an_instance_of(Rubicante::Website)
  end

  it "should require a name parameter for initialization" do
    lambda { Website.new.should raise_error(ArgumentError) }
  end

  it "should return the HTTP code number for a site" do
    Net::HTTP.stub!(:get_response).and_return(@http_redirect)
    @website.response_code.should == "301"
  end

  it "should return true for good websites" do
    Net::HTTP.stub!(:get_response).and_return(@http_ok)
    @website.is_ok?.should == true
  end

  it "should return true for redirected websites" do
    Net::HTTP.stub!(:get_response).and_return(@http_redirect)
    @website.is_ok?.should == true
  end

  it "should return false for websites having problems" do
    Net::HTTP.stub!(:get_response).and_return(@http_server_error)
    @website.is_ok?.should == false
  end

  it "should return false for missing files" do
    Net::HTTP.stub!(:get_response).and_return(@http_client_error)
    @website.is_ok?.should == false
  end

  it "should return a WebsiteError for bad sites" do
    Net::HTTP.stub!(:get_response).and_return(@http_server_error)
    @website.wrong?.should be_an_instance_of(Rubicante::WebsiteError)
  end
end
