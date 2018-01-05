# frozen_string_literal: true

require 'thor/group'

require_relative 'command/behavior'

module Charyf
  module Generators
    include Charyf::Command::Behavior

    REMOVED_GENERATORS = %w(app cli_app intents)


    DEFAULT_ALIASES = {}

    DEFAULT_OPTIONS = {
        charyf: {
            intent_generators: [],
            intents: true
        }
    }

    class << self

      def aliases #:nodoc:
        @aliases ||= DEFAULT_ALIASES.dup
      end

      def options #:nodoc:
        @options ||= DEFAULT_OPTIONS.dup
      end

      # Returns an array of generator namespaces that are hidden.
      # Generator namespaces may be hidden for a variety of reasons.
      def hidden_namespaces
        @hidden_namespaces ||= []
      end

      def hide_namespaces(*namespaces)
        hidden_namespaces.concat(namespaces)
      end

      alias hide_namespace hide_namespaces

      # Show help message with available generators.
      def help(command = "generate")
        puts "Usage: charyf #{command} GENERATOR [args] [options]"
        puts
        puts "General options:"
        puts "  -h, [--help]     # Print generator's options and usage"
        puts "  -p, [--pretend]  # Run but do not make any changes"
        puts "  -f, [--force]    # Overwrite files that already exist"
        puts "  -s, [--skip]     # Skip files that already exist"
        puts "  -q, [--quiet]    # Suppress status output"
        puts
        puts "Please choose a generator below."
        puts

        print_generators
      end

      # Receives a namespace, arguments and the behavior to invoke the generator.
      # It's used as the default entry point for generate, destroy and update
      # commands.
      def invoke(namespace, args = ARGV, config = {})
        names = namespace.to_s.split(":")
        if klass = find_by_namespace(names.pop, names.any? && names.join(":"))
          args << "--help" if args.empty? && klass.arguments.any?(&:required?)
          klass.start(args, config)
        else
          options     = sorted_groups.flat_map(&:last)
          suggestions = options.sort_by { |suggested| levenshtein_distance(namespace.to_s, suggested) }.first(3)
          suggestions.map! { |s| "'#{s}'" }
          msg =  "Could not find generator '#{namespace}'. ".dup

          if suggestions.any?
            msg << "Maybe you meant #{ suggestions[0...-1].join(', ')} or #{suggestions[-1]}\n"
            msg << "Run `charyf generate --help` for more options."
          end

          puts msg
        end
      end

      def configure!(config) #:nodoc:
        options.deep_merge! config.options, union_arrays: true
        hide_namespaces(*config.hidden_namespaces)
      end

      def print_generators
        sorted_groups.each { |b, n| print_list(b, n) }
      end

      def sorted_groups
        namespaces = public_namespaces
        namespaces.sort!

        groups = Hash.new { |h, k| h[k] = [] }
        namespaces.each do |namespace|
          base = namespace.split(":").first
          groups[base] << namespace
        end

        charyf = groups.delete("charyf") || []
        charyf.map! { |n| n.sub(/^charyf:/, "") }
        REMOVED_GENERATORS.map { |name| charyf.delete(name) }

        hidden_namespaces.each { |n| groups.delete(n.to_s) }

        [[ "charyf", charyf ]] + groups.sort.to_a
      end

      def public_namespaces
        subclasses.map(&:namespace)
      end

      # Charyf finds namespaces similar to Thor, it only adds one rule:
      #
      #   find_by_namespace :foo, :charyf, :bar
      #
      # Will search for the following generators:
      #
      #   "charyf:foo", "foo:bar", "foo"
      #
      # Notice that "charyf:generators:bar" could be loaded as well, what
      # Charyf looks for is the first and last parts of the namespace.
      def find_by_namespace(name, base = nil, context = nil) #:nodoc:
        lookups = []
        lookups << "#{base}:#{name}"    if base
        lookups << "#{name}:#{context}" if context

        unless base || context
          unless name.to_s.include?(?:)
            lookups << "#{name}:#{name}"
            lookups << "charyf:#{name}"
          end
          lookups << "#{name}"
        end

        namespaces = Hash[subclasses.map { |klass| [klass.namespace, klass] }]
        lookups.each do |namespace|

          klass = namespaces[namespace]
          return klass if klass
        end

        invoke_fallbacks_for(name, base) || invoke_fallbacks_for(context, name)
      end

      # Hold configured generators fallbacks. If a plugin developer wants a
      # generator group to fallback to another group in case of missing generators,
      # they can add a fallback.
      #
      # For example, shoulda is considered a test_framework and is an extension
      # of test_unit. However, most part of shoulda generators are similar to
      # test_unit ones.
      #
      # Shoulda then can tell generators to search for test_unit generators when
      # some of them are not available by adding a fallback:
      #
      #   Charyf::Generators.fallbacks[:shoulda] = :test_unit
      def fallbacks
        @fallbacks ||= {}
      end

      private

      # Try fallbacks for the given base.
      def invoke_fallbacks_for(name, base)
        return nil unless base && fallbacks[base.to_sym]
        invoked_fallbacks = []

        Array(fallbacks[base.to_sym]).each do |fallback|
          next if invoked_fallbacks.include?(fallback)
          invoked_fallbacks << fallback

          klass = find_by_namespace(name, fallback)
          return klass if klass
        end

        nil
      end

    end # End of self

  end
end
