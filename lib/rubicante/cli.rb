require 'rubicante/environment'
require 'rubicante/default_appender'

require 'logging'

module Rubicante
  # A command-line interface for Rubicante
  class CLI
    def initialize(debug = false)
      # Set up the logger for this CLI session
      @log = Logging.logger['rubicante']

      # Setup the default layout pattern
      layout = Logging::Layouts::Pattern.new
      layout.pattern="%d (%l) %m <%c>\n"

      # Set the layout to the stdout appender
      appender = Logging.appenders.stdout
      appender.layout=layout

      Logging.logger['rubicante'].add_appenders(appender)
      @log.level = debug ? :debug : :info

      # Set up logger for Environment
      Logging.logger['Rubicante::Environment'].add_appenders(Logging.appenders.stdout)
      Logging.logger['Rubicante::Environment'].level = @log.level

      # Prepare Environment
      @env = Environment.new
    end

    def process(resp)
      if resp.kind_of? HostError
        process_host_error(resp)
      end
    end

    def process_host_error(resp)
      if not resp.ping
        puts_error(resp.hostname, "is unreachable.")
      else
        process_port_errors(resp)
        process_service_errors(resp)
        process_website_errors(resp)
      end
    end

    def process_port_errors(resp)
      resp.bad_ports.each do |bad_port|
        puts_error(resp.hostname, "port #{bad_port} is closed.")
      end
    end

    def process_service_errors(resp)
      resp.bad_services.each do |bad_service|
        puts_error(resp.hostname, "service #{bad_service} is stopped.")
      end
    end

    def process_website_errors(resp)
      resp.website_errors.each do |website_error|
        puts_error(resp.hostname, "is returning code #{website_error.code} for website #{website_error.url}.")
      end
    end

    def puts_error(hostname, error)
      @log.info "[#{hostname}] #{error}"
    end

    # Load in a file, executing each line
    def load(file)
      @log.debug "Checking for file: #{file}..."

      if File.exist?(file)
        cmds = File.new(file)
        cmds.each_line { |cmd| handle(cmd) }
      else
        @log.error "File #{file} cannot be found."
      end
    end

    # Handles sending the command to the Environment and dealing
    # with any return values that require output to the user
    def handle(cmd)
      exit if cmd == "exit"

      begin
        result = @env.eval_command(cmd)
      rescue NotImplementedError
        @log.error "Unrecognized command '#{cmd.split[0]}'."
      end

      # 'what' commands return Arrays
      if result.kind_of? Array
        result.each do |response|
          process(response)
        end
      end
    end

    def run
      while true do
        print 'rubicante> '

        cmd = gets.downcase.strip

        handle(cmd)
      end
    end
  end
end
