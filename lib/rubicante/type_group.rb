require 'singleton'
require 'rubicante/type'

module Rubicante
  class TypeGroup
    include Singleton

    attr_accessor :types

    def initialize
      @types  = {}
    end

    def [](type_name)
      @types[type_name] ||= Type.new(type_name)
    end
  end
end
