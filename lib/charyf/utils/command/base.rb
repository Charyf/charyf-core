# frozen_string_literal: true

require 'thor'
require 'erb'

require_relative 'actions'

module Charyf
  module Command
    class Base < Thor
      class Error < Thor::Error # :nodoc:
      end

      include Actions

      class << self

        # Tries to get the description from a USAGE file one folder above the command
        # root.
        def desc(usage = nil, description = nil, options = {})
          if usage
            super
          else
            @desc ||= ERB.new(File.read(desc_file)).result(binding) if desc_file
          end
        end

        def desc_file(desc_file = nil)
          @desc_file = desc_file if desc_file

          @desc_file if @desc_file && File.exist?(@desc_file)
        end

        # Convenience method to get the namespace from the class name. It's the
        # same as Thor default except that the Command at the end of the class
        # is removed.
        def namespace(name = nil)
          if name
            super
          else
            @namespace ||= super.chomp("_command").sub(/:command:/, ":")
          end
        end

        # Convenience method to hide this command from the available ones when
        # running charyf help command.
        def hide_command!
          Charyf::Command.hidden_commands << self
        end

        def inherited(base) #:nodoc:
          super

          if base.name && base.name !~ /Base$/
            Charyf::Command.subclasses << base
          end
        end

        def perform(command, args, config) # :nodoc:
          if Charyf::Command::HELP_MAPPINGS.include?(args.first)
            command, args = "help", []
          end

          dispatch(command, args.dup, nil, config)
        end

        def printing_commands
          namespaced_commands
        end

        def executable
          "bin/charyf #{command_name}"
        end

        def banner(*)
          "#{executable} #{arguments.map(&:usage).join(' ')} [options]".squish
        end

        # Sets the base_name taking into account the current class namespace.
        #
        #   Charyf::Command::TestCommand.base_name # => 'charyf'
        def base_name
          @base_name ||= begin
            if base = name.to_s.split("::").first
              base.underscore
            end
          end
        end

        # Return command name without namespaces.
        #
        #   Charyf::Command::TestCommand.command_name # => 'test'
        def command_name
          @command_name ||= begin
            if command = name.to_s.split("::").last
              command.chomp!("Command")
              command.underscore
            end
          end
        end

        private
        # Allow the command method to be called perform.
        def create_command(meth)
          if meth == "perform"
            alias_method command_name, meth
          else
            # Prevent exception about command without usage.
            # Some commands define their documentation differently.
            @usage ||= ""
            @desc ||= ""

            super
          end
        end

        def command_root_namespace
          (namespace.split(":") - %w( charyf )).first
        end

        def namespaced_commands
          commands.keys.map do |key|
            key == command_root_namespace ? key : "#{command_root_namespace}:#{key}"
          end
        end
      end

      def help
        if command_name = self.class.command_name
          self.class.command_help(shell, command_name)
        else
          super
        end
      end

    end
  end
end
