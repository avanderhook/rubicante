require 'rubicante/website_error'

require 'logging'
require 'net/http'

module Rubicante
  class Website
    attr_reader :fqdn, :path, :url
    
    def initialize(url)
      @log = Logging.logger[self]

      @log.warn "Recieved HTTPS (TCP/443) URL. This version of Rubicante will only check HTTP (TCP/80) when the check is run" if url =~ /^https/

      url.gsub!(/^http[s]?:\/\//, '')   # strip http or https :// off of the front of the URL

      url_parts = url.split('/')        # break the URL down into an array of FQDN and path element
      @fqdn = url_parts.slice!(0)       # slice off the first item, which is the FQDN
      @log.debug "Determined website's FQDN to be '#{@fqdn}'"

      @path = '/' + url_parts.join('/') # join remaining elements to create the path (path will always be at least '/')
      @log.debug "Determined website's path to be '#{@path}'"

      @url = @fqdn + @path
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

      begin
        result = Net::HTTP.get_response(@fqdn, @path).code
        @log.debug "Received HTTP Code #{result} for website '#{@url}'"
      rescue SocketError
        @log.error "Communication problem with '#{@fqdn}'--possibly a DNS error.  Cannot check status!"
        result = "200"
      end

      return result
    end

    # Checks to see if the site is OK.  If it is not, it returns
    # a Rubicante::WebsiteError
    def wrong?
      if not self.is_ok?
        WebsiteError.new(@url, self.response_code)
      end
    end
  end
end
