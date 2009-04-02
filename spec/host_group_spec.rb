require File.join(File.expand_path(File.dirname(__FILE__)),"helper")
require "#{LIB_DIR}/host_group" 

describe "A group of hosts" do
  before :each do
    @host_group = Rubicante::HostGroup.instance
  end

  it "should exist" do
    @host_group.should_not be_nil
    @host_group.should be_an_instance_of(Rubicante::HostGroup)
  end

  it "should have an empty hash of hosts by default" do
    @host_group.hosts.should == {}
  end

  it "should create a new host in hosts if it doesn't exist" do
    hostname = "new-host"
    @host_group[hostname].name.should == hostname
  end

  it "should allow for modifying previously defined hosts" do
    hostname    = "new-host"
    new_port    = 80
    new_service = "new-service"

    @host_group[hostname].port(new_port).service(new_service)

    @host_group[hostname].ports.include?(new_port).should == true
    @host_group[hostname].services.include?(new_service).should == true
  end
end
