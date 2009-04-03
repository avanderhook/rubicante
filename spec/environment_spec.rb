require File.join(File.expand_path(File.dirname(__FILE__)),"helper")
require "#{LIB_DIR}/environment" 

describe "A Rubicante environment" do
  before :all do
    Net::HTTP.stub!(:get_response).and_return(Net::HTTPServerError.new('1', '500', 'Internal Server Error'))
  end

  before :each do
    @env = Rubicante::Environment.new
  end

  it "should exist" do
    @env.should_not be_nil
    @env.should be_an_instance_of(Rubicante::Environment)
  end

  it "should have a HostGroup" do
    @env.host.should be_an_instance_of(Rubicante::HostGroup)
  end

  it "should have an empty HostGroup by default" do
    @env.host.hosts.should == {}
  end

  it "should have a wrong? method" do
    @env.respond_to?('wrong?').should == true
  end

  it "should return an array of HostErrors" do
    @env.wrong? do |result|
      result.should be_an_instance_of(Array)
      result[0].should be_an_instance_of(Rubicante::HostError)
    end
  end

  it "should have an eval_host method" do
    @env.respond_to?('eval_host').should == true
  end

  it "should handle 'Host webservice provides website ...'" do
    hostname = 'webservice'
    url = 'www.rubicante-example.com'
    cmd = "Host #{hostname} provides website #{url}"
    @env.eval_host(cmd)
    @env.host[hostname].websites[0].url.should == url
  end

  it "should handle specifying multiple websites" do
    hostname = 'www2'
    url0 = 'test1'
    url1 = 'test2'
    cmd = "Host #{hostname} provides website #{url0}, provides website #{url1}"
    @env.eval_host(cmd)
    @env.host[hostname].websites[0].url.should == url0
    @env.host[hostname].websites[1].url.should == url1
  end

  it "should have an eval_command method" do
    @env.respond_to?('eval_command').should == true
  end

  it "should raise a NotImplementedError for unknown commands" do
    lambda { @env.eval_command('whumpus frumpus') }.should raise_error(NotImplementedError)
  end

  it "should handle 'host' commands" do
    lambda { @env.eval_command('host frank') }.should_not raise_error(NotImplementedError)
  end

  it "should have an eval_what method" do
    @env.respond_to?('eval_what').should == true
  end

  it "should handle 'what' commands" do
    lambda { @env.eval_command('What is wrong') }.should_not raise_error(NotImplementedError)
  end

  after :each do
    # Clean up the HostGroup instance's hash so that other specs will
    # run properly
    @env.host.hosts.clear
  end
end
