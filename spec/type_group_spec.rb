require File.join(File.expand_path(File.dirname(__FILE__)),"helper")
require "#{LIB_DIR}/type_group" 

describe "A group of server types" do
  before :each do
    @type_group = Rubicante::TypeGroup.instance
  end

  it "should exist" do
    @type_group.should_not be_nil
    @type_group.should be_an_instance_of(Rubicante::TypeGroup)
  end

  it "should have an empty hash of types by default" do
    @type_group.types.should == {}
  end

  it "should create a new type in types if it doesn't exist" do
    type_name = "new-type"
    @type_group[type_name].name.should == type_name
  end

  it "should allow for modifying previously defined types" do
    type_name   = "new-type"
    new_port    = 80
    new_service = "new-service"
    @type_group[type_name]

    @type_group[type_name].port(new_port)
    @type_group[type_name].ports.include?(new_port).should == true

    @type_group[type_name].service(new_service)
    @type_group[type_name].services.include?(new_service).should == true
  end

  it "should include PortsMethods" do
    pending
  end

  it "should include ServiceMethods" do
    pending
  end

  it "should report downed ports" do
    pending
  end

  it "should report downed services" do
    pending
  end

  it "should report both downed services and ports when wrong() is called" do
    pending
  end
end
