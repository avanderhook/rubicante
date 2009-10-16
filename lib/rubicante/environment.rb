require 'rubicante/host_group'
require 'os_functions'

require 'logging'

module Rubicante
  class Environment
    include OsFunctions

    attr_accessor :host

    def initialize
      @host = HostGroup.instance

      @log = Logging.logger['rubicante']

      if is_windows?
        @log.debug "Detected base operating platform is Windows-based"
      else
        @log.debug "Detected base operating platform is NON Windows-based"
      end
    end

    # Evaluate a command, sending it off to the appropriate
    # 'eval_*' method.  Otherwise, through a NotImplementedError
    def eval_command(cmd)
      if cmd =~ /^[#]/
        @log.debug "Determined command to be a comment, skipping"
        return
      end

      if not cmd =~ /\S/
        @log.debug "Line is blank, skipping"
        return
      end

      cmd_root = 'eval_' + cmd.split[0].downcase
      @log.debug "Received #{cmd_root} command: '#{cmd}'"

      if self.respond_to?(cmd_root)
        self.send(cmd_root, cmd)
      else
        raise NotImplementedError
      end
    end

    def polish_cleanup(cmd)
      cmd.gsub!(/,/, '')    # clean up commas
      cmd.gsub!(/[\s]/, '') # clean up white space
    end

    # Perform polish on a command starting with 'host' and
    # evaluate it
    def eval_host(cmd)
      cmd.gsub!(/^[Hh]ost\s([\S]+)[\s]?/, 'host["\1"]')
      cmd.gsub!(/website\s([^,]+)/, '.website("\1")')
      cmd.gsub!(/port\s([^,]+)/, '.port(\1)')
      cmd.gsub!(/service\s([^,]+)/, '.service("\1")')

      # Clean up some bubble words
      cmd.gsub!(/listens\son\s/, '')
      cmd.gsub!(/provides\s/, '')

      polish_cleanup(cmd)

      @log.debug "Evaluating polished 'host' command: #{cmd}"
      instance_eval cmd
    end

    # Perform polish on a command starting with 'what' and
    # evaluate it
    def eval_what(cmd)
      cmd.gsub!(/[Hh]ost[s]?\s/, 'hosts')
      cmd.gsub!(/[Ss]ervice [Pp]ack\s/, '.sp_level')
      cmd.gsub!(/([\s]*)<([\s]*)([\S]+)/, '_lt(\3)')

      # Clean up some bubble words
      cmd.gsub!(/^[Ww]hat\s/, '')
      cmd.gsub!(/is\s/, '')
      cmd.gsub!(/have\s/, '')

      polish_cleanup(cmd)

      @log.debug "Evaluating polished 'what' command: #{cmd}"
      instance_eval cmd
    end

    def sp_level_lt(version)
      if is_windows?
        result = []

        host.hosts.keys.each do |key|
          result << host[key].sp_level_lt(version)
        end
      end
    end

    def wrong?
      @log.debug "Checking environment for things that are wrong"
      result = []

      host.hosts.keys.each do |key|
        result << host[key].wrong?
      end

      return result
    end
    alias_method :wrong, :wrong?
  end
end
