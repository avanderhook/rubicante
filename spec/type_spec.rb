require File.join(File.expand_path(File.dirname(__FILE__)),"helper")
require "#{LIB_DIR}/type" 

describe "A server type" do
  before :each do
    @type_name = "spec-type"
    @type = Rubicante::Type.new(@type_name)
  end

  it "should exist" do
    @type.should_not be_nil
    @type.should be_an_instance_of(Rubicante::Type)
  end

  it "should require a name when initializing" do
    lambda { @new_type = Rubicante::Type.new }.should raise_error(ArgumentError)
  end

  it "should have a name" do
    @type.name.should == @type_name
  end

  it "should have an empty array of ports by default" do
    @type.ports.should == []
  end

  it "should have an empty array of services by default" do
    @type.services.should == []
  end

  it "should allow appending of ports" do
    new_port = 80
    @type.port(new_port)
    @type.ports.include?(new_port).should == true
  end

  it "should allow appending of services" do
    new_service = "W32Time"
    @type.service(new_service)
    @type.services.include?(new_service).should == true
  end
end
