require_relative '../initializable'

module Charyf
  class Application
    module Bootstrap

      include Charyf::Initializable

      class InitializationError < StandardError; end

      initializer :load_environment, group: :all do
        Charyf.logger.info "Charyf starting in #{Charyf.env} mode."


        # noinspection RubyResolve
        require self.config.root.join('config', 'environments', "#{Charyf.env}.rb")
      end

      initializer :validate_strategies, group: :all do
        raise InitializationError.new('No strategy for session processor found') unless Charyf.application.session_processor
        raise InitializationError.new('No strategy for intent processor found') unless Charyf.application.intent_processor
      end

      initializer :load_apps, group: :all do
        # noinspection RubyResolve
        require self.config.root.join('app', 'application_controller.rb')

        # TODO Load apps / skills
      end

      initializer :load_initializers, group: :all do
        # Load initializer files
      end


    end
  end
end