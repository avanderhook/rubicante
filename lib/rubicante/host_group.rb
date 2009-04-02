require 'singleton'
require 'rubicante/host'

module Rubicante
  class HostGroup
    include Singleton

    attr_reader :hosts

    def initialize
      @hosts = {}
    end

    def [](hostname)
      @hosts[hostname] ||= Host.new(hostname)
    end
  end
end
