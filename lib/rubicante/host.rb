require 'net/http'

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
      @websites << website_url
      self
    end

    # Performs and HTTP GET on the URL's root ('/') and determines
    # whether or not the page is functioning properly.
    #
    # == Is The Site Functioning?
    #
    # When performing an HTTP GET on the root, if a 2xx (HTTP OK) or
    # 3xx (HTTP Redirect) response is received, the method considers the
    # site to be workinging nominally.
    #
    # However, if a 4xx (HTTP Client Error) or 5xx (HTTP Server Error)
    # response is received, the method considers the site to be working
    # abnormally.
    #
    # == Returns: a Hash
    #
    #   {
    #     :is_up => boolean, # whether or not the page is ok (see above)
    #     :code  => String   # the HTTP status code (i.e., "200", "301", "401", "500", etc.)
    #   }
    #
    # == Example
    #
    #   host = Rubicante::Host.new("test-host")
    #   response = host.check_website('www.example.com')
    #
    #   puts response[:is_up]
    #   puts response[:code]
    def check_website(website_url)
      result = {:is_up  => false,
                :code   => nil,
                :url    => website_url
      }
      
      result[:code]   = Net::HTTP.get_response(website_url, '/').code
      result[:is_up]  = true if result[:code].match(/^(2|3)/)

      return result
    end

    # Iterates through all the websites in the object and runs
    # them against ((<check_website>)), appending each websites'
    # URL to the results before ((*yield*))ing them.
    #
    # == Yields: a Hash
    #
    #   {
    #     :is_up  => boolean, # see ((<check_website>)) for more information
    #     :code   => String,  # see ((<check_website>)) for more information
    #     :url    => String   # the URL of the current website in the block
    #   }
    #
    # == Example
    #
    #   host = Rubicante::Host.new("test-host")
    #   host.website('www.exmaple.com')
    #   host.website('www.rubicante.com')
    #   host.website('www.openbsd.org')
    #
    #   host.check_websites |response|
    #     puts "Checking site '#{response[:url]}'..."
    #     puts "Site returned HTTP Code #{response[:code]}"
    #
    #     if response[:is_up]
    #       puts "Site is OK"
    #     else
    #       puts "Site is NOT WORKING!"
    #     end
    #   end
    def check_websites
      @websites.each do |url|
        result = check_website(url)
        result[:url] = url
        yield result
      end
    end
  end
end
