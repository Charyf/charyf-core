# frozen_string_literal: true

require_relative '../../command/base'
require_relative '../../command/environment_argument'

module Charyf

  class Console
    def self.start(*args)
      new(*args).start
    end

    attr_reader :options, :app, :console

    def initialize(app, options = {})
      @app     = app
      @options = options

      @console = app.config.console || IRB
    end

    def environment
      options[:environment]
    end

    alias_method :environment?, :environment

    def set_environment!
      Charyf.env = environment
    end

    def start
      set_environment! if environment?

      puts "Loading #{Charyf.env} environment (Charyf #{Charyf.version})"

      console.start
    end
  end

  module Command

    class ConsoleCommand < Base # :nodoc:

      include EnvironmentArgument

      hide_command!

      def initialize(args = [], local_options = {}, config = {})
        console_options = []

        # For the same behavior as OptionParser, leave only options after "--" in ARGV.
        termination = local_options.find_index("--")
        if termination
          console_options = local_options[termination + 1..-1]
          local_options = local_options[0...termination]
        end

        ARGV.replace(console_options)
        super(args, local_options, config)
      end

      def perform
        extract_environment_option

        # CHARYF_ENV needs to be set before application is required.
        ENV["CHARYF_ENV"] = options[:environment]

        require_application_and_environment!

        Charyf::Console.start(Charyf.application, options)
      end

    end
  end
end