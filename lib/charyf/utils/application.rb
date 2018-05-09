require_relative 'configuration'

require_relative 'application/configuration'
require_relative 'application/bootstrap'

require_relative 'app_engine'
require_relative 'utils'

require_relative '../support'

module Charyf
  class Application < AppEngine

    include Charyf::Initializable

    class << self
      attr_accessor :called_from

      def inherited(base)
        super
        Charyf.app_class = base

        base.called_from = begin
          call_stack = caller_locations.map { |l| l.absolute_path || l.path }

          File.dirname(call_stack.detect { |p| p !~ %r[charyf[\w.-]*/lib/utils] })
        end
      end

      def instance
        super.run_load_hooks!
      end

      def find_root(from)
        Charyf::Utils.find_root_with_flag 'config/chapp.rb', from
      end

      def config
        instance.config
      end

    end

    def initialize!(group = :default)
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

    def interfaces
      # TODO resolve dependency on engine - maybe move the base classes to utils?
      config.enabled_interfaces.map do |interface_name|
        klass = Charyf::Interface.list[interface_name]
        raise Charyf::Utils::InvalidConfiguration.new("No interface with name '#{interface_name}' found") unless klass

        klass
      end
    end

    def dispatcher
      # TODO resolve dependency on engine - maybe move the base classes to utils?
      klass = Charyf::Engine::Dispatcher.list[config.dispatcher]
      raise Charyf::Utils::InvalidConfiguration.new("No dispatcher with name '#{config.dispatcher}' found") unless klass

      klass
    end

    def storage_provider
      klass = Charyf::Utils::StorageProvider.list[config.storage_provider]
      raise Charyf::Utils::InvalidConfiguration.new("No storage provider with name '#{config.storage_provider}' found") unless klass

      klass
    end

    def routing
      klass = Charyf::Engine::Routing.list[config.router]

      raise Charyf::Utils::InvalidConfiguration.new("No router with name '#{config.router}' found") unless klass

      klass
    end

    def routes
      @routes ||= routing.new
    end

    protected

    def run_generators_blocks(app) #:nodoc:
      extensions.each { |r| r.run_generators_blocks(app) }
      super
    end

    def initializers
      Bootstrap.initializers_for(self) +
          (extensions.map { |e| e.class.initializers_for(self) }.flatten)
    end

    private

    def extensions
      @extensions ||= Extensions.new
    end

  end
end