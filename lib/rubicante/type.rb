module Rubicante
  class Type
    attr_reader :name
    attr_accessor :ports, :services

    def initialize(name)
      @name     = name
      @ports    = []
      @services = []
    end

    def port(new_port)
      @ports << new_port
    end

    def service(new_service)
      @services << new_service
    end
  end
end
