require_relative 'application/configuration'
require_relative 'application/bootstrap'
require_relative 'tools'

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
        Charyf::Tools.find_root_with_flag 'config.ru', from, Dir.pwd
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
      klass = Charyf::Engine::Session::Processors.list[config.session_processor]
      klass ? klass.new : nil
    end

    def intent_processor
      # TODO resolve dependency on engine - maybe move the base classes to utils?
      klass = Charyf::Engine::Intent::Processors.list[config.intent_processor]
      klass ? klass.new : nil
    end

    protected

    def initializers
      Bootstrap.initializers_for(self)
    end

  end
end