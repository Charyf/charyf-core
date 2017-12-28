# frozen_string_literal: true

require_relative '../../command/base'

module Charyf
  module Command
    class GenerateCommand < Base # :nodoc:

      no_commands do
        def help
          require_application_and_environment!
          load_generators

          Charyf::Generators.help self.class.command_name
        end
      end

      def perform(*)
        generator = args.shift
        return help unless generator

        require_application_and_environment!
        load_generators

        ARGV.shift

        Charyf::Generators.invoke generator, args, behavior: :invoke, destination_root: Charyf::Command.root
      end
    end
  end
end
