require 'rubicante/host_group'

module Rubicante
  class Environment
    attr_accessor :host

    def initialize
      @host = HostGroup.instance
    end

    def eval_host(cmd)
      cmd.gsub!(/^[Hh]ost\s([\S]+)\s/, 'host["\1"]')
      cmd.gsub!(/website\s([^,]+)/, '.website("\1")')

      # Clean up some bubble words
      cmd.gsub!(/provides\s/, '')
      cmd.gsub!(/,/, '')    # clean up commas
      cmd.gsub!(/[\s]/, '') # clean up white space

      puts cmd

      eval cmd
    end

    def wrong?
      host.hosts do |host|
        yield host.wrong?
      end
    end
  end
end
