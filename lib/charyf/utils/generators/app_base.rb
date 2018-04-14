# frozen_string_literal: true

require 'fileutils'

require_relative '../generator/base'
require_relative '../generators'
require_relative '../../version'

require_relative 'defaults'

module Charyf
  module Generators
    module ActionMethods # :nodoc:
      attr_reader :options

      def initialize(generator)
        @generator = generator
        @options = generator.options
      end

      private
      %w(destination_root template copy_file directory empty_directory inside
         empty_directory_with_keep_file keep_file create_file chmod run shebang
         gem_group gem gemfile_entries).each do |method|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}(*args, &block)
            @generator.send(:#{method}, *args, &block)
          end
        RUBY
      end
    end

    class AppBase < Base # :nodoc:
      add_shebang_option!

      argument :app_path, type: :string

      def self.strict_args_position
        false
      end

      def self.add_shared_options_for(name)

        class_option :intent_processors,   type: :array, default: Defaults::SETTINGS[:intents],
                                           desc: "Set of intent intent processors to be included in installation" + Defaults.intents_desc,
                                           group: :strategies

        class_option :storage_provider, type: :string, default: Defaults::SETTINGS[:storage],
                                           desc: "Storage provider to be installed by default." + Defaults.storage_desc,
                                           group: :strategies



        class_option :skip_gemfile,        type: :boolean, default: false,
                                           desc: "Don't create a Gemfile"

        class_option :skip_git,            type: :boolean, aliases: "-G", default: false,
                                           desc: "Skip .gitignore file"

        class_option :skip_keeps,          type: :boolean, default: false,
                                           desc: "Skip source control .keep files"

        class_option :lib,                 type: :boolean, aliases: "-L", default: false,
                                           desc: "Install Charyf as library to existing project"

        class_option :dev,                 type: :boolean, default: false,
                                           desc: "Setup the #{name} with Gemfile pointing to your Charyf checkout"

        class_option :edge,                type: :boolean, default: false,
                                           desc: "Setup the #{name} with Gemfile pointing to Charyf repository"

        class_option :help,                type: :boolean, aliases: "-h", group: :charyf,
                                           desc: "Show this help message and quit"
      end

      def initialize(*args)
        @gem_filter    = lambda { |gem| true }
        @extra_entries = []
        super
      end
    #
    private

      def gemfile_entry(name, *args) # :doc:
        options = args.extract_options!
        version = args.first
        github = options[:github]
        path   = options[:path]

        if github
          @extra_entries << GemfileEntry.github(name, github)
        elsif path
          @extra_entries << GemfileEntry.path(name, path)
        else
          @extra_entries << GemfileEntry.version(name, version)
        end
        self
      end

      def gemfile_entries # :doc:
        [charyf_gemfile_entry,
         intents_gemfile_entries,
         storage_gemfile_entries,
         @extra_entries].flatten.find_all(&@gem_filter)
      end

      def add_gem_entry_filter # :doc:
        @gem_filter = lambda { |next_filter, entry|
          yield(entry) && next_filter.call(entry)
        }.curry[@gem_filter]
      end

      def builder # :doc:
        @builder ||= begin
          builder_class = get_builder_class
          builder_class.include(ActionMethods)
          builder_class.new(self)
        end
      end

      def build(meth, *args) # :doc:
        builder.send(meth, *args) if builder.respond_to?(meth)
      end

      def create_root # :doc:
        valid_const?

        empty_directory "."
        FileUtils.cd(destination_root) unless options[:pretend]
      end

      def set_default_accessors! # :doc:
        self.destination_root = File.expand_path(app_path, destination_root)

        if options[:lib]
          # Instantiate app name beforehand
          app_name

          self.destination_root = File.expand_path('charyf', destination_root)
        end
      end

      def keeps? # :doc:
        !options[:skip_keeps]
      end

      def lib?
        options[:lib]
      end

      def intents_details
        Defaults::INTENT_PROCESSORS.select { |ip| options[:intent_processors].include?(ip.to_s) }
      end

      def storage_details
        storage = Defaults::STORAGE_PROVIDERS[options[:storage_provider].to_sym]
        $stderr.puts "Unknown storage provider '#{options[:storage_provider]}'" unless storage

        storage
      end

      class GemfileEntry < Struct.new(:name, :version, :comment, :options, :commented_out)
        def initialize(name, version, comment, options = {}, commented_out = false)
          super
        end

        def self.github(name, github, branch = nil, comment = nil)
          if branch
            new(name, nil, comment, github: github, branch: branch)
          else
            new(name, nil, comment, github: github)
          end
        end

        def self.version(name, version, comment = nil)
          new(name, version, comment)
        end

        def self.path(name, path, comment = nil)
          new(name, nil, comment, path: path)
        end

        def version
          version = super

          if version.is_a?(Array)
            version.join("', '")
          else
            version
          end
        end
      end

      def charyf_gemfile_entry
        if options.dev?
          [
            GemfileEntry.path("charyf", Charyf::Generators::CHARYF_DEV_PATH)
          ]
        elsif options.edge?
          [
            GemfileEntry.github("charyf", "Charyf/charyf-core", nil,
                                "Bundle edge Charyf instead: gem 'charyf', github: 'charyf/charyf-core'")
          ]
        else
          [GemfileEntry.version("charyf",
                            charyf_version_specifier)]
        end
      end

      def intents_gemfile_entries
        intents_details.values.map do |details|
          GemfileEntry.version(details[:gem], details[:gem_version], 'Intent processor [generated]')
        end
      end

      def storage_gemfile_entries
        details = storage_details
        GemfileEntry.version(details[:gem], details[:gem_version], 'Storage provider [generated]')
      end

      def charyf_version_specifier(gem_version = Charyf.gem_version)
        if gem_version.segments.size == 3 || gem_version.release.segments.size == 3
          # ~> 1.2.3
          # ~> 1.2.3.pre4
          "~> #{gem_version}"
        else
          # ~> 1.2.3, >= 1.2.3.4
          # ~> 1.2.3, >= 1.2.3.4.pre5
          patch = gem_version.segments[0, 3].join(".")
          ["~> #{patch}", ">= #{gem_version}"]
        end
      end

      def bundle_command(command)
        say_status :run, "bundle #{command}"

        # We are going to shell out rather than invoking Bundler::CLI.new(command)
        # because `charyf new` loads the Thor gem and on the other hand bundler uses
        # its own vendored Thor, which could be a different version. Running both
        # things in the same process is a recipe for a night with paracetamol.
        #
        # We unset temporary bundler variables to load proper bundler and Gemfile.
        #
        # Thanks to James Tucker for the Gem tricks involved in this call.
        _bundle_command = Gem.bin_path("bundler", "bundle")

        require "bundler"
        Bundler.with_clean_env do
          full_command = %Q["#{Gem.ruby}" "#{_bundle_command}" #{command}]
          if options[:quiet]
            system(full_command, out: File::NULL)
          else
            system(full_command)
          end
        end
      end

      def bundle_install?
        !(options[:skip_gemfile] || options[:skip_bundle] || options[:pretend])
      end

      def run_bundle
        bundle_command("install") if bundle_install?
      end

      def empty_directory_with_keep_file(destination, config = {})
        empty_directory(destination, config)
        keep_file(destination)
      end

      def keep_file(destination)
        create_file("#{destination}/.keep") if keeps?
      end
    end
  end
end
