require_relative '../app_engine'
require_relative '../initializable'
require_relative '../utils'
require 'i18n'

module Charyf
  class Application < AppEngine
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
      # Nothing loaded unless environment file exists
      #
      initializer :load_environment, group: :all do
        Charyf.logger.info "Charyf starting in #{Charyf.env} mode."

        env_file = self.config.root.join('config', 'environments', "#{Charyf.env}.rb")

        if FileTest.exists?(env_file)
          require env_file
        end
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
        Charyf.application.session_processor
        Charyf.application.intent_processors
        Charyf.application.dispatcher
      end

      #
      # Load APP default files
      #
      initializer :load_defaults, group: :all do
        require self.config.root.join('app', 'skill_controller.rb')

      end

      #
      # Find all skills located in [YourApp]/app/skills/
      #
      initializer :load_skill_dir, group: :all do
        # TODO revisit this
        condition = lambda do |path|
          in_root_dir = path.dirname.basename.to_s == 'skills'
          contain_skill = Dir[path.dirname.join('**', '**')].any? { |p| p.include?('/controllers') } &&
                          Dir[path.dirname.join('**', '**')].any? { |p| p.include?('/intents') }
          return in_root_dir || contain_skill
        end

        # Require skill level files
        Charyf::Utils.require_recursive self.config.root.join('app', 'skills'),
                                        condition: condition

        # Require controllers
        Charyf::Skill.list.each do |skill_klass|
          # Load initializers
          root = skill_klass.skill_root

          Dir[root.join('controllers', '**', '*.rb')].each do |controller|
            require controller
          end
        end
      end

      #
      # Load all intents
      #
      initializer :load_skill_intents, groups: :all do
        # Require Skill intents
        Charyf::Skill.list.each do |skill_klass|
          Dir[skill_klass.routing_source_dir.join('**', '*.rb')].each do |file|
            require file
          end
        end

        Charyf::Skill.list.each do |skill_klass|
          skill_name = skill_klass.skill_name

          Charyf.application.intent_processors.each do |processor|
            # Public routing
            skill_klass._public_routing(processor.strategy_name).each do |block|
              processor.get_global.load skill_name, block
            end

            # Private routing
            skill_klass._private_routing(processor.strategy_name).each do |block|
              processor.get_for(skill_name).load skill_name, block
            end

          end
        end
      end

      #
      # Load all user skill files
      #  - controllers
      #
      initializer :load_skill_controllers, group: :all do

        Charyf::Skill.list.each do |skill_klass|

          # Load controllers
          root = skill_klass.skill_root

          Dir[root.join('controllers', '**', '*.rb')].each do |controller|
            require controller
          end

        end
      end

      #
      # Load user initializer files
      #
      initializer :run_initializers, group: :all do
        Dir[self.config.root.join('config', 'initializers', '**', '**.rb')].each do |initializer|
          require initializer
        end

        Charyf::Skill.list.each do |skill_klass|
          # Load initializers
          root = skill_klass.skill_root

          Dir[root.join('initializers', '**', '*.rb')].each do |initializer|
            require initializer
          end
        end
      end

    end
  end
end