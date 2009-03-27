require File.join(File.expand_path(File.dirname(__FILE__)),"helper")
require "#{LIB_DIR}/host" 

describe "A newtork host" do
  before :each do
    @host_name = "spec-host"
    @host = Rubicante::Host.new(@host_name)

    @test_url = "http://www.rubicante-test.com/"

    @http_ok           = Net::HTTPOK.new('1', '200', 'OK')
    @http_redirect     = Net::HTTPMovedPermanently.new('1', '301', 'Moved Permanently')
    @http_client_error = Net::HTTPNotFound.new('1', '404', 'File Not Found')
    @http_server_error = Net::HTTPInternalServerError.new('1', '500', 'Internal Server Error')
  end

  it "should exist" do
    @host.should_not be_nil
    @host.should be_an_instance_of(Rubicante::Host)
  end

  it "should require a name parameter for initialization" do
    lambda { Host.new.should raise_error(ArgumentError) }
  end

  it "should have an empty array of ports by default" do
    @host.ports.should == []
  end

  it "should allow adding more ports with port()" do
    port = 12345
    @host.port(port)
    @host.ports.include?(port).should == true
  end

  it "should return self for port()" do
    @host.port(12345).should be_an_instance_of(Rubicante::Host)
  end

  it "should have an empty array of services by default" do
    @host.services.should == []
  end

  it "should allow adding more services with service()" do
    service = "W32Time"
    @host.service(service)
    @host.services.include?(service).should == true
  end

  it "should return self for service()" do
    @host.service("test").should be_an_instance_of(Rubicante::Host)
  end

  it "should have an empty array of types" do
    @host.types.should == []
  end

  it "should allow adding more types with type()" do
    type = "SQL Server"
    @host.type(type)
    @host.types.include?(type).should == true
  end

  it "should return self for type()" do
    @host.type("testing").should be_an_instance_of(Rubicante::Host)
  end

  it "should have an empty array of websites by default" do
    @host.websites.should == []
  end

  it "should allow adding more webistes with site()" do
    url = "http://www.example.com/"
    @host.website(url)
    @host.websites.include?(url).should == true
  end

  it "should return self for site()" do
    @host.website("http://www.example.com/").should be_an_instance_of(Rubicante::Host)
  end

  def check_website
    result = @host.check_website(@test_url)
    result[:is_up]
  end

  it "should return true for good websites" do
    Net::HTTP.stub!(:get_response).and_return(@http_ok)
    check_website.should == true
  end

  it "should return true for redirected websites" do
    Net::HTTP.stub!(:get_response).and_return(@http_redirect)
    check_website.should == true
  end

  it "should return false for websites having problems" do
    Net::HTTP.stub!(:get_response).and_return(@http_server_error)
    check_website.should == false
  end

  it "should return false for missing files" do
    Net::HTTP.stub!(:get_response).and_return(@http_client_error)
    check_website.should == false
  end

  it "should return the HTTP code number for a site" do
    Net::HTTP.stub!(:get_response).and_return(@http_redirect)
    @host.check_website(@test_url)[:code].should == "301"
  end

  it "should check all websites" do
    sites = [
      'www.rubicante-good-site.com',
      'www.rubicante-bad-site.com',
      'www.rubicante-worse-site.com',
      'www.rubicante-redirect.com'
    ]

    my_host = Rubicante::Host.new("new-host")
    sites.each do |site|
      my_host.website(site)
    end

    Net::HTTP.stub!(:get_response).and_return(@http_ok)

    my_host.check_websites do |result|
      sites.include?(result[:url]).should == true
    end
  end
end
