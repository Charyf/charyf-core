require_relative '../initializable'
require 'i18n'

module Charyf
  class Application
    # noinspection RubyResolve
    module Bootstrap

      class SkillLoadError < StandardError
        def initialize(e, skill_name, skill_path)
          super(e)

          @_name = skill_name
          @_path = skill_path.dirname
        end

        def message
          _message + super
        end

        def _message
          <<-EOS
          
          Unable to load skill #{@_name}
          Expected to find: '#{@_name}.rb'
                Located at: '#{@_path}'

EOS
        end
      end

      include Charyf::Initializable

      class InitializationError < StandardError; end

      #
      # Load app environment configuration files
      # Default application configuration is when a command is triggered
      #
      initializer :load_environment, group: :all do
        Charyf.logger.info "Charyf starting in #{Charyf.env} mode."


        require self.config.root.join('config', 'environments', "#{Charyf.env}.rb")
      end

      #
      # Loads I18N
      #
      initializer :load_i18n, group: :all do
        I18n.load_path << Dir[Charyf._gem_source.join('locale', '**', '*.yml').to_s]
      end

      #
      # Validates that all required strategies are fulfilled and the application can load
      #
      initializer :validate_strategies, group: :all do
        raise InitializationError.new('No session processor found') unless Charyf.application.session_processor

        intent_processors = Charyf.application.intent_processors
        if intent_processors.empty? || intent_processors.include?(nil)
          raise InitializationError.new("Invalid set of intent processors #{Charyf.application.config.enabled_intent_processors}")
        end
      end

      #
      # Load APP default files
      #
      initializer :load_defaults, group: :all do
        require self.config.root.join('app', 'application_controller.rb')

      end

      #
      # Load user initializer files
      #
      initializer :run_initializers, group: :all do
        # Load initializer files
      end

      #
      # Find all skills located in [YourApp]/app/skills/
      #
      initializer :list_skills, group: :all do
        skills = Dir.entries(self.config.root.join('app', 'skills'))
                     .select {|entry| File.directory? self.config.root.join('app', 'skills', entry) and !(entry =='.' || entry == '..') }

        skills.each do |skill_name|
          skill_path = self.config.root.join('app', 'skills', skill_name, "#{skill_name}.rb")

          begin
            require skill_path.to_s
          rescue LoadError => e
            raise SkillLoadError.new(e, skill_name, skill_path)
          end
        end
      end

      #
      # Init all intent parsers
      #
      initializer :init_intent_parsers, group: :all do
        Charyf.application.intent_processors.each do |parser|
          parser.class.setup
        end
        # Charyf.
        #
        # file_pattern = "*.#{Charyf.application.config.intent_processor.to_s}.rb"
        #
        # Charyf::Skill.list.each do |skill_klass|
        #
        #   # Load routing
        #   root = skill_klass.skill_root
        #
        #   Dir[root.join('intents', '**', file_pattern)].each do |routing|
        #     require routing
        #   end
        #
        # end
      end

      #
      # Init session processor
      #
      initializer :init_session_processor, group: :all do

      end

      #
      # Init storage provider
      #
      initializer :init_storage_provider, group: :all do

      end

      #
      # Init selected dispatcher
      #
      initializer :init_dispatcher, group: :all do

      end

      #
      # Load all user skill files
      #
      initializer :load_skills, group: :all do

        Charyf::Skill.list.each do |skill_klass|

          # Load controllers
          root = skill_klass.skill_root

          Dir[root.join('controllers', '**', '*.rb')].each do |controller|
            require controller
          end

        end
      end

    end
  end
end