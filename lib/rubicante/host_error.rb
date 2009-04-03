require 'rubicante/website_error'

module Rubicante
  class HostError
    attr_reader :hostname, :website_errors
    attr_accessor :ping

    def initialize(hostname)
      @hostname = hostname
      @ping = false
      @website_errors  = []
    end

    def add(error)
      if error.kind_of? WebsiteError
        @website_errors << error
      end
    end
  end
end
