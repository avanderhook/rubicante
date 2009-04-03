require 'rubicante/environment'

require 'logging'

module Rubicante
  # A command-line interface for Rubicante
  class CLI
    def initialize
      # Set up the logger for this CLI session
      @log = Logging::Logger['rubicante']
      @log.add_appenders(Logging::Appender.stdout)
      @log.level = :debug

      # Set up logger for Environment
      Logging::Appender['rubicante'] = Logging::Appender.stdout
      Logging::Logger['Rubicante::Environment'].add_appenders(Logging::Appender['rubicante'])
      Logging::Logger['Rubicante::Environment'].level = @log.level

      # Prepare Environment
      @env = Environment.new
    end

    def process(resp)
      if resp.kind_of? HostError
        process_hosterror(resp)
      end
    end

    def process_hosterror(resp)
      if not resp.ping
        puts_error(resp.hostname, "is unreachable.")
      else
        process_website_errors(resp)
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

    def run
      while true do
        print 'rubicante> '

        cmd = gets.downcase.strip

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
    end
  end
end
