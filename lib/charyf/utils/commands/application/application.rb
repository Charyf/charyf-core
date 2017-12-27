# frozen_string_literal: true

require_relative '../../generators'
require_relative '../../generators/app/app_generator'

module Charyf
  module Generators
    class CliAppGenerator < AppGenerator # :nodoc:
      # We want to exit on failure to be kind to other libraries
      # This is only when accessing via CLI
      def self.exit_on_failure?
        true
      end
    end
  end

  module Command
    class ApplicationCommand < Base # :nodoc:
      hide_command!

      def help
        perform # Punt help output to the generator.
      end

      def perform(*args)
        Charyf::Generators::CliAppGenerator.start \
          Charyf::Generators::ARGVScrubber.new(args).prepare!
      end
    end
  end
end
