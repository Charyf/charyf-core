require_relative '../../utils'

require_relative '../context'
require_relative '../request'

module Charyf
  module Engine
    module Dispatcher
      class Base

        include Charyf::Strategy
        def self.base
          Base
        end

        sig ['Charyf::Engine::Request'], nil,
        def dispatch(request)
        end

        def self.setup
          # Do your setup here
        end


        protected

        def self.intent_processors
          Charyf.application.intent_processors
        end

        def self.session_processor
          Charyf.application.session_processor
        end

        def intent_processors
          self.class.intent_processors
        end

        def session_processor
          self.class.session_processor
        end

        sig ['Charyf::Engine::Context'], nil,
        def spawn_controller(context)
          begin
            prepare_context context

            Charyf.logger.flow_request("[FLOW] Dispatching request [#{context.request.inspect}]" +
                                        ", detected intent: [#{context.intent.inspect}]" +
                                        ", session : [#{context.session.inspect}]"
            )

            controller = get_controller(context)

            handle_before_actions(controller)
            controller.send(context.action_name)
            handle_after_actions(controller)
          rescue Exception => e
            # Dispatch the error to all error handlers
            Charyf.configuration.error_handlers.handle_exception(e)

            # Catch any error that may occur inside the user controller
            controller.send(:reply, text: 'There was a problem processing your request. Check the logs please.')
          end

        end

        private

        def prepare_context(context)
          context.intent ||= Charyf::Engine::Intent::UNKNOWN

          context
        end

        def get_controller(context)
          controller_name = context.full_controller_name +  'Controller'

          Object.const_get(controller_name).new(context)
        end

        def get_action_name(context)
          if context.session && context.session.action
            return context.session.action
          end

          context.intent.action
        end

        def handle_before_actions(controller)
          action = controller.action_name

          # Handle before actions
          controller.class._before_actions(action).each do |method_name|
            controller.send(method_name)
          end

        end

        def handle_after_actions(controller)
          action = controller.action_name

          # Auto render responses
          if controller.class._render_on? action
            controller.send(:reply)
          end
        end

      end # End of Base.class

      def self.known
        Base.known
      end

      def self.list
        Base.list
      end

    end
  end
end