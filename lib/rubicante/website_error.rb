module Rubicante
  class WebsiteError
    attr_reader :code, :url

    def initialize(url, code)
      @url  = url
      @code = code
    end
  end
end
