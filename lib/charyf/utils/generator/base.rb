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
      end
      #
      # class_option :skip_namespace, type: :boolean, default: false,
      #              desc: "Skip namespace (affects only isolated applications)"
      #
      # add_runtime_options!
      # strict_args_position!
      #
      # Returns the source root for this generator using default_source_root as default.
      def self.source_root(path = nil)
        @_source_root = path if path
        @_source_root ||= default_source_root
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

      # Returns the default source root for a given generator. This is used internally
      # by rails to set its generators source root. If you want to customize your source
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
      # Rails::Generators::ModelGenerator will return "model" as generator name.
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
      #
      # def self.usage_path # :doc:
      #   paths = [
      #       source_root && File.expand_path("../USAGE", source_root),
      #       default_generator_root && File.join(default_generator_root, "USAGE")
      #   ]
      #   paths.compact.detect {|path| File.exist? path}
      # end

      def self.default_generator_root # :doc:
        path = File.expand_path(File.join('..', 'generators', generator_name), base_root)
        path if File.exist?(path)
      end

    end
  end
end
