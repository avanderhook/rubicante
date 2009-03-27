require 'net/http'

module Rubicante
  class Website
    attr_reader :url
    
    def initialize(url)
      @url = url
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

      result
    end

    # Performs and HTTP GET on the URL's root ('/') and returns the
    # HTTP Status code
    def response_code
      Net::HTTP.get_response(@url, '/').code
    end
  end
end
