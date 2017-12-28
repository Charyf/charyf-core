# frozen_string_literal: true

require_relative '../app_base'
require_relative '../../../support'

module Charyf
  module Generators
    # The application builder allows you to override elements of the application
    # generator without being forced to reverse the operations of the default
    # generator.
    #
    # This allows you to override entire operations, like the creation of the
    # Gemfile, README, or JavaScript files, without needing to know exactly
    # what those operations do so you can create another template action.
    #
    #  class CustomAppBuilder < Charyf::Generators::AppBuilder
    #    def test
    #      @generator.gem "rspec", group: [:development, :test]
    #      run "bundle install"
    #      generate "rspec:install"
    #    end
    #  end
    class AppBuilder
      # def rakefile
      #   template "Rakefile"
      # end
      #
      def readme
        copy_file 'README.md', 'README.md'
      end

      def gemfile
        template 'Gemfile.erb', 'Gemfile'
      end

      def update_gemfile

        gemfile_entries.each do |entry|
          options = entry.options.dup
          options[:comment] = entry.comment if entry.comment && !entry.comment.empty?

          versions = entry.version ? entry.version.split(", ") : nil

          args = [entry.name, versions, options].flatten.compact

          @generator.gem *args
        end

      end

      def gitignore
        template 'gitignore', '.gitignore'
      end

      def version_control
        if !options[:skip_git] && !options[:pretend]
          run "git init", capture: options[:quiet]
        end
      end

      def app
        directory "app"

        empty_directory_with_keep_file "app/skills"
      end

      def bin
        directory "bin" do |content|
          "#{shebang}\n" + content
        end

        chmod "bin", 0755 & ~File.umask, verbose: false
      end

      def config
        empty_directory "config"

        inside "config" do
          template "application.rb"
          template "boot.rb"
          template "chapp.rb"
          template "load.rb"

          directory "environments"
          empty_directory_with_keep_file "initializers"
        end
      end

      def lib
        empty_directory "lib"
      end

      def log
        empty_directory_with_keep_file "log"
      end

      def tmp
        empty_directory_with_keep_file "tmp"
      end
    end

    CHARYF_DEV_PATH = File.expand_path('../../../../..', __dir__)
    RESERVED_NAMES = %w[application skill plugin runner test generator install new]

    class AppGenerator < AppBase # :nodoc:
      #   WEBPACKS = %w( react vue angular elm )

        add_shared_options_for 'application'

        desc_file File.expand_path('USAGE', __dir__)

        class_option :version, type: :boolean, aliases: "-v", group: :charyf,
                               desc: "Show Charyf version number and quit"

      #   class_option :api, type: :boolean,
      #                      desc: "Preconfigure smaller stack for API only apps"

        class_option :skip_bundle, type: :boolean, aliases: "-B", default: false,
                     desc: "Don't run bundle install"

        def initialize(*args)
          super
          if options[:lib]
            self.options = options.merge(skip_git: true).freeze
          end

        end
      #
        public_task :set_default_accessors!
        public_task :create_root
      #
        def create_root_files
          build(:readme)
          build(:gitignore)   unless options[:skip_git]
          build(:version_control)


          unless options[:skip_gemfile]
            if options[:lib]

              begin
                # Temporary change root
                self.destination_root = File.expand_path('..', destination_root)
                if File.exist?(File.join(destination_root, 'Gemfile'))
                  build(:update_gemfile)
                else
                  build(:gemfile)
                end
              ensure
                self.destination_root = File.expand_path('charyf', destination_root)
              end

            else
              build(:gemfile)
            end
          end
        end

        def create_app_files
          build(:app)
        end

        def create_bin_files
          build(:bin)
        end

        def create_config_files
          build(:config)
        end

        def create_lib_files
          build(:lib)
        end

        def create_log_files
          build(:log)
        end

        def create_tmp_files
          build(:tmp)
        end

        public_task :run_bundle

        def run_after_bundle_callbacks
          @after_bundle_callbacks.each(&:call)
        end

        def self.banner
          "charyf new #{arguments.map(&:usage).join(' ')} [options] \n"
        end

      private

        def app_name
          @app_name ||= (defined_app_const_base? ? defined_app_name : File.basename(destination_root)).tr('\\', "").tr(". ", "_")
        end

        def defined_app_name
          defined_app_const_base.underscore
        end

        def defined_app_const_base
          Charyf.respond_to?(:application) && defined?(Charyf::Application) &&
            Charyf.application.is_a?(Charyf::Application) && Charyf.application.class.name.sub(/::Application$/, "")
        end
        #
        alias :defined_app_const_base? :defined_app_const_base

        def app_const_base
          @app_const_base ||= defined_app_const_base || app_name.gsub(/\W/, "_").squeeze("_").camelize
        end
        alias :camelized :app_const_base

        def app_const
          @app_const ||= "#{app_const_base}::Application"
        end

        def valid_const?
          if app_const =~ /^\d/
            raise Error, "Invalid application name #{app_name}. Please give a name which does not start with numbers."
          elsif RESERVED_NAMES.include?(app_name)
            raise Error, "Invalid application name #{app_name}. Please give a " \
                         "name which does not match one of the reserved charyf " \
                         "words: #{RESERVED_NAMES.join(", ")}"
          elsif Object.const_defined?(app_const_base)
            raise Error, "Invalid application name #{app_name}, constant #{app_const_base} is already in use. Please choose another application name."
          end
        end

        def get_builder_class
          defined?(::AppBuilder) ? ::AppBuilder : Charyf::Generators::AppBuilder
        end
    end

    # This class handles preparation of the arguments before the AppGenerator is
    # called.
    #
    # This class should be called before the AppGenerator is required and started
    # since it configures and mutates ARGV correctly.
    class ARGVScrubber # :nodoc:

      VERSION_ARGS = %w(--version -v)

      def initialize(argv = ARGV)
        @argv = argv
      end

      #
      def prepare!
        handle_version_request!(@argv.first)
        handle_invalid_command!(@argv.first, @argv) do
          return @argv.drop(1)
        end
      end

      private

      def handle_version_request!(argument)
        if VERSION_ARGS.include?(argument)
          require_relative '../../../version'
          puts "Charyf #{Charyf.version}"
          exit(0)
        end
      end

      def handle_invalid_command!(argument, argv)
        if argument == 'new'
          yield
        else
          ['--help'] + argv.drop(1)
        end
      end

    end
  end
end
