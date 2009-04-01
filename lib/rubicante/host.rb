require 'rubicante/website'

module Rubicante
  class Host
    attr_reader :name
    attr_accessor :ports, :services, :types, :websites

    def initialize(name)
      @name     = name
      @ports    = []
      @services = []
      @types    = []
      @websites = []
    end

    def port(port_number)
      @ports << port_number
      self
    end

    def service(service_name)
      @services << service_name
      self
    end

    def type(type_name)
      @types << type_name
      self
    end

    def website(website_url)
      @websites << Website.new(website_url)
      self
    end

    # Iterates through all the websites in the Host and runs
    # is_ok? against them looking for problems.  If a problem is
    # found, a Hash of the URL and the HTTP Status code is yielded.
    #
    # == Yields: a Hash
    #
    #   {
    #     :url    => String,  # the URL of the current website in the block
    #     :code   => String   # the HTTP Status code of the check (i.e., 404, 500, etc.)
    #   }
    #
    # == Example
    #
    #   host = Rubicante::Host.new("test-host")
    #   host.website('www.exmaple.com')
    #   host.website('www.rubicante.com')
    #   host.website('www.openbsd.org')
    #
    #   host.check_websites |result|
    #     puts "Website #{result[:url]} failed with code #{result[:code]}!"
    #   end
    def check_websites
      @websites.each do |website|
        yield website.wrong?
      end
    end
  end
end
