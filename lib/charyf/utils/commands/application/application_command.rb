# frozen_string_literal: true

require_relative '../../generators'
require_relative '../../generators/app/app_generator'

module Charyf
  module Command
    class ApplicationCommand < Base # :nodoc:
      hide_command!

      def help
        perform # Punt help output to the generator.
      end

      def perform(*args)
        Charyf::Generators::AppGenerator.start \
          Charyf::Generators::ARGVScrubber.new(args).prepare!
      end
    end
  end
end
