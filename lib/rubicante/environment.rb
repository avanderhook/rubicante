require 'rubicante/host_group'

module Rubicante
  class Environment
    attr_accessor :host

    def initialize
      @host = HostGroup.instance
    end

    # Evaluate a command, sending it off to the appropriate
    # 'eval_*' method.  Otherwise, through a NotImplementedError
    def eval_command(cmd)
      cmd_root = 'eval_' + cmd.split[0].downcase

      if self.respond_to?(cmd_root)
        self.send(cmd_root, cmd)
      else
        raise NotImplementedError
      end
    end

    # Perform polish on a command starting with 'host' and
    # evaluate it
    def eval_host(cmd)
      cmd.gsub!(/^[Hh]ost\s([\S]+)\s/, 'host["\1"]')
      cmd.gsub!(/website\s([^,]+)/, '.website("\1")')

      # Clean up some bubble words
      cmd.gsub!(/provides\s/, '')
      cmd.gsub!(/,/, '')    # clean up commas
      cmd.gsub!(/[\s]/, '') # clean up white space

      eval cmd
    end

    # Perform polish on a command starting with 'what' and
    # evaluate it
    def eval_what(cmd)
      # Clean up some bubble words
      cmd.gsub!(/^[Ww]hat\s/, '')
      cmd.gsub!(/is\s/, '')

      eval cmd
    end

    def wrong?
      host.hosts do |host|
        yield host.wrong?
      end
    end
    alias_method :wrong, :wrong?
  end
end
