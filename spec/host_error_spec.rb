require File.join(File.expand_path(File.dirname(__FILE__)),"helper")
require "#{LIB_DIR}/host_error" 

describe "An error with a host" do
  before :all do
    @url = "http://www.rubicante-example.com/"
    @code = "500"
    @website_error = Rubicante::WebsiteError.new(@url, @code)
  end

  before :each do
    @host_error = Rubicante::HostError.new("test-host")
  end

  it "should exist" do
    @host_error.should_not be_nil
    @host_error.should be_an_instance_of(Rubicante::HostError)
  end

  it "should require an argument at initialization" do
    lambda { Rubicante::HostError.new }.should raise_error(ArgumentError)
  end

  it "should now allow changing of hostname after initialization" do
    lambda { @host_error.hostname = "new-host-name" }.should raise_error(NoMethodError)
  end

  it "should have an empty array of website errors" do
    @host_error.website_errors.should == []
  end

  it "should allow adding of new website errors with add" do
    @host_error.add(@website_error)
    @host_error.website_errors.include?(@website_error).should == true
  end

  it "should have an ping value" do
    @host_error.respond_to?('ping').should == true
  end

  it "ping should be false by default" do
    @host_error.ping.should == false
  end

  it "should allow changin the ping value" do
    @new_ping = true
    @host_error.ping.should_not == @new_ping
    @host_error.ping = @new_ping
    @host_error.ping.should == @new_ping
  end

  it "should have an empty array of bad_ports by default" do
    @host_error.bad_ports.should == []
  end

  it "should allow appending to bad_ports" do
    new_bad_port = 80
    @host_error.bad_ports << new_bad_port
    @host_error.bad_ports.include?(new_bad_port).should == true
  end

  it "should have an empty array of bad_services by default" do
    pending
    @host_error.bad_services.should == []
  end

  it "should allow appending to bad_services" do
    pending
    new_bad_service = 'W32Time'
    @host_error.bad_services << new_bad_service
    @host_error.bad_services.include?(new_bad_service).should == true
  end
end
