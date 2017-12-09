require_relative 'application/configuration'
require_relative 'application/bootstrap'
require_relative 'utils'

module Charyf
  class Application

    include Charyf::Initializable

    class << self
      attr_accessor :called_from

      def inherited(base)
        super
        Charyf.app_class = base

        base.called_from = begin
          call_stack = caller_locations.map { |l| l.absolute_path || l.path }

          File.dirname(call_stack.detect { |p| p !~ %r[railties[\w.-]*/lib/rails|rack[\w.-]*/lib/rack] })
        end
      end

      def instance
        @instance ||= self.new

        @instance.run_load_hooks!

        @instance
      end

      def find_root(from)
        Charyf::Utils.find_root_with_flag 'config/chapp.rb', from
      end

      def config
        instance.config
      end

    end

    def initialize!(group: :default)
      return self if @initialized
      @initialized = true

      run_initializers(group, self)
    end

    def run_load_hooks!
      return self if @ran_load_hooks
      @ran_load_hooks = true

      # Todo LOAD Hooks should be here
      self
    end

    def config
      @config ||= Application::Configuration.new(self.class.find_root(self.class.called_from))
    end

    def configure(&block)
      instance_eval(&block)
    end

    # TODO sig, nullable
    def session_processor
      # TODO resolve dependency on engine - maybe move the base classes to utils?
      klass = Charyf::Engine::Session::Processor.list[config.session_processor]
      raise Charyf::Utils::InvalidConfiguration.new("No storage processor strategy with name '#{config.session_processor}' found") unless klass

      klass
    end

    def intent_processors
      # TODO resolve dependency on engine - maybe move the base classes to utils?
      klasses = config.enabled_intent_processors.map do |processor_name|
        klass = Charyf::Engine::Intent::Processor.list[processor_name]
        raise Charyf::Utils::InvalidConfiguration.new("No intent processor strategy with name '#{processor_name}' found") unless klass

        klass
      end

      raise Charyf::Utils::InvalidConfiguration.new('No intent processor strategies specified') if klasses.empty?

      klasses
    end

    def dispatcher
      # TODO resolve dependency on engine - maybe move the base classes to utils?
      klass = Charyf::Engine::Dispatcher.list[config.dispatcher]
      raise Charyf::Utils::InvalidConfiguration.new("No dispatcher with name '#{config.dispatcher}' found") unless klass

      klass
    end

    # TODO sig, nullable
    def storage_provider
      klass = Charyf::Utils::StorageProvider.list[config.storage_provider]
      raise Charyf::Utils::InvalidConfiguration.new("No storage provider with name '#{config.storage_provider}' found") unless klass

      klass
    end

    def parser
      klass = Charyf::Utils::Parser.get(config.i18n.locale)
      raise Charyf::Utils::InvalidConfiguration.new("No parser for locale '#{config.i18n.locale}' found") unless klass

      klass
    end

    protected

    def initializers
      Bootstrap.initializers_for(self)
    end

  end
end