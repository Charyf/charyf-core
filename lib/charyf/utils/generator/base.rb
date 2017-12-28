# frozen_string_literal: true

begin
  require 'thor/group'
rescue LoadError
  puts "Thor is not available.\nIf you ran this command from a git checkout " \
       "of Charyf, please make sure thor is installed,\nand run this command " \
       "as `ruby #{$0} #{(ARGV | ['--dev']).join(" ")}`"
  exit
end

require_relative 'actions'

module Charyf
  module Generators
    class Error < Thor::Error # :nodoc:
    end

    class Base < Thor::Group
      include Thor::Actions
      include Charyf::Generators::Actions

      add_runtime_options!
      strict_args_position!

      # Cache source root and add lib/generators/base/generator/templates to
      # source paths.
      def self.inherited(base) #:nodoc:
        super

        # Invoke source_root so the default_source_root is set.
        base.source_root

        if base.name && base.name !~ /Base$/
          Charyf::Generators.subclasses << base
        end

      end

      # Tries to get the description from a USAGE file one folder above the command
      # root.
      def self.desc(usage = nil, description = nil, options = {})
        if usage
          super
        else
          @desc ||= ERB.new(File.read(desc_file)).result(binding) if desc_file
        end
      end

      def self.desc_file(desc_file = nil)
        @desc_file = desc_file if desc_file

        @desc_file if @desc_file && File.exist?(@desc_file)
      end

      def self.hook_for(*names, &block)
        options = names.last.is_a?(Hash) ? names.pop : {}
        in_base = options.delete(:in) || base_name
        as_hook = options.delete(:as) || generator_name

        names.each do |name|
          unless class_options.key?(name)
            defaults = if options[:type] == :boolean
                         {}
                       elsif [true, false].include?(default_value_for_option(name, options))
                         { banner: "", type: :boolean }
                       elsif default_value_for_option(name, options).is_a? Array
                         { desc: "#{name.to_s} to be invoked", banner: "NAMES", type: :array }
                       else
                         { desc: "#{name.to_s} to be invoked", banner: "NAME" }
                       end

            class_option(name, defaults.merge!(options))
          end

          hooks[name] = [ in_base, as_hook ]
          invoke_from_option(name, options, &block)
        end
      end

      # # Remove a previously added hook.
      # #
      # #   remove_hook_for :orm
      # def self.remove_hook_for(*names)
      #   remove_invocation(*names)
      #
      #   names.each do |name|
      #     hooks.delete(name)
      #   end
      # end
      #
      # Make class option aware of Charyf::Generators.options
      def self.class_option(name, options = {}) #:nodoc:
        options[:desc]    = "Indicates when to generate #{name.to_s.downcase}" unless options.key?(:desc)
        options[:default] = default_value_for_option(name, options)
        super(name, options)
      end

      # Returns the source root for this generator using default_source_root as default.
      def self.source_root(path = nil)
        @_source_root = path if path
        @_source_root ||= default_source_root || super
      end

      # Convenience method to get the namespace from the class name. It's the
      # same as Thor default except that the Generator at the end of the class
      # is removed.
      def self.namespace(name = nil)
        return super if name
        @namespace ||= super.sub(/_generator$/, "").sub(/:generators:/, ":")
      end

      # Convenience method to hide this generator from the available ones when
      # running charyf generator command.
      def self.hide!
        Charyf::Generators.hide_namespace(namespace)
      end

      protected

      # Shortcut to invoke with padding and block handling. Use internally by
      # invoke and invoke_from_option class methods.
      def _invoke_for_class_method(klass, command = nil, *args, &block) #:nodoc:
        with_padding do
          if block
            case block.arity
              when 3
                yield(self, klass, command)
              when 2
                yield(self, klass)
              when 1
                instance_exec(klass, &block)
            end
          else
            invoke klass, command, *args
          end
        end
      end

      # Prepare class invocation to search on Charyf namespace if a previous
      # added hook is being used.
      def self.prepare_for_invocation(name, value) #:nodoc:
        return super unless value.is_a?(String) || value.is_a?(Symbol) #|| value.is_a?(Array)

        if value && constants = hooks[name]
          value = name if TrueClass === value
          Charyf::Generators.find_by_namespace(value, *constants)
        elsif klass = Charyf::Generators.find_by_namespace(value)
          klass
        else
          super
        end
      end

      private

      # Keep hooks configuration that are used on prepare_for_invocation.
      def self.hooks #:nodoc:
        @hooks ||= from_superclass(:hooks, {})
      end


      # Returns the default value for the option name given doing a lookup in
      # Charyf::Generators.options.
      def self.default_value_for_option(name, options) # :doc:
        default_for_option(Charyf::Generators.options, name, options, options[:default])
      end

      # Returns default for the option name given doing a lookup in config.
      def self.default_for_option(config, name, options, default) # :doc:
        if generator_name && (c = config[generator_name.to_sym]) && c.key?(name)
          c[name]
        elsif base_name && (c = config[base_name.to_sym]) && c.key?(name)
          c[name]
        elsif config[:charyf].key?(name)
          config[:charyf][name]
        else
          default
        end
      end

      # Returns the default source root for a given generator. This is used internally
      # by Charyf to set its generators source root. If you want to customize your source
      # root, you should use source_root.
      def self.default_source_root
        return unless base_name && generator_name
        return unless default_generator_root
        path = File.join(default_generator_root, "templates")
        path if File.exist?(path)
      end

      # Returns the base root for a common set of generators. This is used to dynamically
      # guess the default source root.
      def self.base_root
        __dir__
      end

      # Use Charyf default banner.
      def self.banner # :doc:
        "charyf generate #{namespace.sub(/^charyf:/, '')} #{arguments.map(&:usage).join(' ')} [options]".gsub(/\s+/, " ")
      end

      # Sets the base_name taking into account the current class namespace.
      def self.base_name # :doc:
        @base_name ||= begin
          if base = name.to_s.split("::").first
            base.underscore
          end
        end
      end

      # Removes the namespaces and get the generator name. For example,
      # Charyf::Generators::SkillGenerator will return "skill" as generator name.
      def self.generator_name # :doc:
        @generator_name ||= begin
          if generator = name.to_s.split("::").last
            generator.sub!(/Generator$/, "")
            generator.underscore
          end
        end
      end

      # # Small macro to add ruby as an option to the generator with proper
      # # default value plus an instance helper method called shebang.
      def self.add_shebang_option! # :doc:
        class_option :ruby, type: :string, aliases: "-r", default: Thor::Util.ruby_command,
                     desc: "Path to the Ruby binary of your choice", banner: "PATH"

        no_tasks {
          define_method :shebang do
            @shebang ||= begin
              command = if options[:ruby] == Thor::Util.ruby_command
                          "/usr/bin/env #{File.basename(Thor::Util.ruby_command)}"
                        else
                          options[:ruby]
                        end
              "#!#{command}"
            end
          end
        }
      end

      def self.default_generator_root # :doc:
        path = File.expand_path(File.join('..', 'generators', generator_name), base_root)
        path if File.exist?(path)
      end

    end
  end
end
