require 'rubicante/host_group'
require 'os_functions'

require 'logging'

module Rubicante
  class Environment
    include OsFunctions

    attr_accessor :host

    def initialize
      @host = HostGroup.instance

      @log = Logging.logger[self]

      if is_windows?
        @log.debug "Detected base operating platform is Windows-based"
      else
        @log.debug "Detected base operating platform is NON Windows-based"
      end

      # Prepare Host logger
      @appender = Logging.logger['rubicante']
      Logging.logger['Rubicante::Host'].add_appenders(Logging.appenders.stdout) if not @appender.nil?
      Logging.logger['Rubicante::Host'].level = @log.level
    end

    # Evaluate a command, sending it off to the appropriate
    # 'eval_*' method.  Otherwise, through a NotImplementedError
    def eval_command(cmd)
      @log.debug "Received command: #{cmd}"

      cmd_root = 'eval_' + cmd.split[0].downcase
      @log.debug "Determined command root to be: #{cmd_root}"

      if self.respond_to?(cmd_root)
        self.send(cmd_root, cmd)
      else
        raise NotImplementedError if not cmd_root == 'eval_#'
      end
    end

    # Perform polish on a command starting with 'host' and
    # evaluate it
    def eval_host(cmd)
      @log.debug "Polishing 'host' command"
      cmd.gsub!(/^[Hh]ost\s([\S]+)\s/, 'host["\1"]')
      cmd.gsub!(/website\s([^,]+)/, '.website("\1")')
      cmd.gsub!(/port\s([^,]+)/, '.port(\1)')
      cmd.gsub!(/service\s([^,]+)/, '.service("\1")')

      # Clean up some bubble words
      cmd.gsub!(/listens\son\s/, '')
      cmd.gsub!(/provides\s/, '')
      cmd.gsub!(/,/, '')    # clean up commas
      cmd.gsub!(/[\s]/, '') # clean up white space

      @log.debug "Evaluating polished 'host' command: #{cmd}"
      instance_eval cmd
    end

    # Perform polish on a command starting with 'what' and
    # evaluate it
    def eval_what(cmd)
      @log.debug "Polishing 'what' command"
      # Clean up some bubble words
      cmd.gsub!(/^[Ww]hat\s/, '')
      cmd.gsub!(/is\s/, '')

      @log.debug "Evaluating polished 'what' command: #{cmd}"
      instance_eval cmd
    end

    def wrong?
      @log.debug "Checking environment for things that are wrong"
      result = []

      host.hosts.keys.each do |key|
        @log.debug "Checking host #{host[key].name}..."
        result << host[key].wrong?
      end

      return result
    end
    alias_method :wrong, :wrong?
  end
end
