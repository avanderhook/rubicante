require 'rubicante/website_error'

require 'logging'
require 'net/http'

module Rubicante
  class Website
    attr_reader :url
    
    def initialize(url)
      @url = url

      @log = Logging::Logger[self]
    end

    # Determines whether or not the site OK based on the HTTP Status code
    #
    # == DETERMINING IF A SITE IS OK
    #
    # When performing an HTTP GET on the root, if a 2xx (HTTP OK) or
    # 3xx (HTTP Redirect) response is received, the method considers the
    # site to be workinging nominally and returns *true*
    #
    # However, if a 4xx (HTTP Client Error) or 5xx (HTTP Server Error)
    # response is received, the method considers the site to be working
    # abnormally and returns *false*
    def is_ok?
      result = false

      result = true if response_code.match(/^(2|3)/)

      return result
    end

    # Performs and HTTP GET on the URL's root ('/') and returns the
    # HTTP Status code
    def response_code
      @log.debug "Retreiving HTTP Code for website '#{@url}'"
      result = Net::HTTP.get_response(@url, '/').code
      @log.debug "Received HTTP Code #{result} for website '#{@url}'"

      return result
    end

    # Checks to see if the site is OK.  If it is not, it returns
    # a Rubicante::WebsiteError
    def wrong?
      @log.debug "Checking website '#{@url}' for problems"
      if not self.is_ok?
        WebsiteError.new(@url, self.response_code)
      end
    end
  end
end
