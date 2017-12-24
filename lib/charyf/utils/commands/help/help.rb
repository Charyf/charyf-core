# frozen_string_literal: true

require_relative '../../command/base'

module Charyf
  module Command
    class HelpCommand < Base # :nodoc:

      hide_command!
      desc_file File.expand_path('USAGE', __dir__)

      def help(*)
        puts self.class.desc

        Charyf::Command.print_commands
      end

    end
  end
end