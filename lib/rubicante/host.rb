require 'rubicante/website'
require 'rubicante/host_error'

require 'logging'
require 'ping'
require 'socket'

require 'os_functions'
include OsFunctions
require 'win32ole' if is_windows?

module Rubicante
  class Host
    include OsFunctions

    attr_reader :name
    attr_accessor :ports, :services, :types, :websites

    def initialize(name)
      @name     = name
      @ports    = []
      @services = []
      @types    = []
      @websites = []

      @log = Logging::Logger[self]

      # Prepare Website logger
      @appender = Logging::Appender['rubicante']
      Logging::Logger['Rubicante::Website'].add_appenders(Logging::Appender['rubicante']) if not @appender.nil?
      Logging::Logger['Rubicante::Website'].level = @log.level
    end

    def ping
      @log.debug "Performing TCP echo ping on host '#{@name}'"
      Ping.pingecho @name
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

    # Check if the specified port is active by connecting to it
    def check_port(port)
      port_output = "#{@name}:#{port}"

      @log.debug "Checking port #{port_output}..."

      begin
        test = TCPSocket.open(@name, port)
        @log.debug "Port #{port_output} looks good"
        return true # if we get here, the socket opened
      rescue
        @log.debug "Port #{port_output} raised an exception when opening"
        return false  # if we get here, there are problems with the port
      end
    end

    # Iterates through all the ports in the Host and runs check_port(port)
    # against them.
    #
    # == Yields: port, is_alive
    #
    # Each registered port is yielded along with the boolean result from
    # check_port(port).
    #
    # == Example:
    #
    #   host = Rubicante::Host.new("test-host")
    #   host.port(80)
    #   host.port(443)
    #
    #   host.check_ports do |port, response|
    #     puts "Port #{port} is UP" if response
    #     puts "Port #{port} is DOWN" if not response
    #   end
    def check_ports
      @ports.each do |port|
        yield port, check_port(port)
      end
    end

    # Iterates through all the websites in the Host and runs
    # wrong? against them looking for problems.  If a problem is
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
    #   host.check_websites do |result|
    #     puts "Website #{result[:url]} failed with code #{result[:code]}!"
    #   end
    def check_websites
      @log.debug "Checking websites registered to host '#{@name}'"
      @websites.each do |website|
        yield website.wrong?
      end
    end

    def wrong?
      @log.debug "Determing what is wrong with host '#{@name}'"
      result = HostError.new(@name)
      result.ping = self.ping

      # If the host is alive, continue testing
      if result.ping
        check_ports do |port, response|
          result.bad_ports << port if not response
        end

        check_websites do |website_error|
          result.add(website_error)
        end

        if is_windows?
          check_services do |service, response|
            result.bad_services << service if not response
          end
        end
      end

      return result
    end

    ###
    # Windows-specific functions
    ###
    if is_windows?
      def get_wmi
        WIN32OLE.connect("winmgmts://#{@name}")
      end

      # Checks the host to see if the specified service is running
      def is_running?(service)
        query = "SELECT Name, State FROM Win32_Service WHERE Name='#{service}'"

        result = false
        service_label = "#{@name}->#{service}"

        @log.debug "Checking services #{service_label}..."
        get_wmi.ExecQuery(query).each do |result|
          @log.debug "#{service_label}.State == #{result.State}"
          result = true if result.State = 'Running'
        end

        return result
      end

      def check_services
        @services.each do |service|
          yield service, is_running?(service)
        end
      end
    end
  end
end
