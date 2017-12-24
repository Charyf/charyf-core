require_relative '../support/object'
require_relative 'command/base'
require_relative 'command/behavior'

module Charyf
  module Command

    HELP_MAPPINGS = %w(-h -? --help)

    include Behavior

    class << self

      def environment # :nodoc:
        ENV['CHARYF_ENV'] ? ENV['CHARYF_ENV'] : 'development'
      end

      def hidden_commands # :nodoc:
        @hidden_commands ||= []
      end

      # Track all command subclasses.
      def subclasses
        @subclasses ||= []
      end

      def load_builtin_commands!
        unless @_commands_loaded
          require_relative 'commands/all'
          @_commands_loaded = true
        end
      end

      # Receives a namespace, arguments and the behavior to invoke the command.
      def invoke(full_namespace, args = [], **config)
        load_builtin_commands!

        namespace = full_namespace = full_namespace.to_s

        if char = namespace =~ /:(\w+)$/
          command_name, namespace = $1, namespace.slice(0, char)
        else
          command_name = namespace
        end

        command_name, namespace = "help", "help" if command_name.blank? || HELP_MAPPINGS.include?(command_name)
        command_name, namespace = "version", "version" if %w( -v --version ).include?(command_name)

        command = find_by_namespace(namespace, command_name)

        # if command && command.all_commands[command_name]
          command.perform(command_name, args, config)
        # else
        #   find_by_namespace("rake").perform(full_namespace, args, config)
        # end
      end

      def find_by_namespace(namespace, command_name = nil) # :nodoc:
        lookups = [namespace]
        lookups << "#{namespace}:#{command_name}" if command_name
        lookups.concat lookups.map {|lookup| "charyf:#{lookup}"}

        namespaces = subclasses.inject(Hash.new) {|h, n| h[n.namespace] = n; h}
        namespaces[(lookups & namespaces.keys).first]
      end

      def print_commands # :nodoc:
        sorted_groups.each {|b, n| print_list(b, n)}
      end

      def sorted_groups # :nodoc:
        groups = (subclasses - hidden_commands).group_by {|c| c.namespace.split(":").first}

        groups.keys.each do |key|
          groups[key] = groups[key].flat_map(&:printing_commands).sort
        end

        charyf = groups.delete('charyf')
        [['charyf', charyf]] + groups.sort.to_a
      end

      private

      def command_type # :doc:
        @command_type ||= "command"
      end

      def lookup_paths # :doc:
        @lookup_paths ||= %w( charyf/commands commands charyf/commands )
      end

      def file_lookup_paths # :doc:
        @file_lookup_paths ||= ["{#{lookup_paths.join(',')}}", "**", "*_command.rb"]
      end

    end # End of self

  end
end