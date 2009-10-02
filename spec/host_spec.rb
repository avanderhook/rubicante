require File.join(File.expand_path(File.dirname(__FILE__)),"helper")
require "#{LIB_DIR}/host" 

describe "A newtork host" do
  before :each do
    @host_name = "spec-host"
    @host = Rubicante::Host.new(@host_name)

    @host_with_sites = Rubicante::Host.new(@host_name)
    @sites = [
      'www.rubicante-good-site.com/',
      'www.rubicante-bad-site.com/',
      'www.rubicante-worse-site.com/',
      'www.rubicante-redirect.com/'
    ]
    @sites.each do |site|
      @host_with_sites.website(site)
    end

    @host_with_ports = Rubicante::Host.new(@host_name)
    @ports = [80, 22, 443]
    @ports.each do |port|
      @host_with_ports.port(port)
    end

    Net::HTTP.stub!(:get_response).and_return(Net::HTTPServerError.new('1', '500', 'Internal Server Error'))
    Ping.stub!(:pingecho).and_return(true)
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
    @host.websites.size.should == 1
  end

  it "should return self for site()" do
    @host.website("http://www.example.com/").should be_an_instance_of(Rubicante::Host)
  end

  it "should check all websites" do
    @host_with_sites.check_websites do |result|
      @sites.include?(result.url).should == true
    end
  end

  it "should return a HostError for wrong?" do
    @host.wrong?.should be_an_instance_of(Rubicante::HostError)
  end

  it "should return website errors with the HostError" do
    host_error = @host.wrong?

    host_error.website_errors.should_not be_nil
    host_error.website_errors.each do |website_error|
      website_error.should be_an_instance_of(Rubicante::WebsiteError)
      @sites.include?(website_error.url).should == true
    end
  end

  it "should support pinging" do
    @host.respond_to?('ping').should == true
  end

  it "should update HostError.ping to true for alive hosts" do
    host_error = @host.wrong?
    host_error.ping.should == true
  end

  it "should update HostError.ping to false for down hosts" do
    Ping.stub!(:pingecho).and_return(false)
    host_error = @host.wrong?
    host_error.ping.should == false
  end

  it "should skip website processing for downed hosts" do
    Ping.stub!(:pingecho).and_return(false)
    host_error = @host_with_sites.wrong?
    host_error.ping.should == false
    host_error.website_errors.should == []
  end

  it "should check a specified port" do
    @host.respond_to?('check_port').should == true
    TCPSocket.stub!(:open).and_return(true)
    @host.check_port(80).should == true
    TCPSocket.stub!(:open).and_raise(ArgumentError)
    @host.check_port(443).should == false
  end

  it "should check all registered ports" do
    TCPSocket.stub!(:open).and_raise(ArgumentError)
    @host_with_ports.check_ports do |port, is_alive|
      @ports.include?(port).should == true
    end
  end

  it "should update HostError.bad_ports for all down ports" do
    TCPSocket.stub!(:open).and_raise(ArgumentError)
    host_error = @host_with_ports.wrong?
    host_error.bad_ports.each do |bad_port|
      @ports.include?(bad_port).should == true
    end
  end
end
