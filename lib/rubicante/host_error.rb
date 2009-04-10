require 'rubicante/website_error'

module Rubicante
  class HostError
    attr_reader :hostname, :website_errors
    attr_accessor :bad_ports, :bad_services, :ping

    def initialize(hostname)
      @hostname = hostname
      @ping = false
      @bad_ports      = []
      @bad_services   = []
      @website_errors = []
    end

    def add(error)
      if error.kind_of? WebsiteError
        @website_errors << error
      end
    end
  end
end
