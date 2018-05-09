require_relative '../../utils'

require_relative '../context'
require_relative '../request'

module Charyf
  module Engine
    module Dispatcher

      extend Charyf::Strategy::OwnerClass

      class Base

        include Charyf::Strategy::BaseClass

        def dispatch(request)
          status, response = dispatch_internal(request)

          {
              status: status,
              response: response,
              request: request
          }
        end

        def dispatch_async(request)
          Charyf::Pipeline.enqueue request

          {
              status: :ASYNC,
              request: request,
              response: nil
          }
        end

        protected

        def dispatch_internal(request)
          raise Charyf::Utils::NotImplemented.new
        end

        def self.intent_processors
          Charyf.application.intent_processors
        end

        def self.session_processor
          Charyf.application.session_processor
        end

        def self.routes
          Charyf.application.routes
        end

        def intent_processors
          self.class.intent_processors
        end

        def session_processor
          self.class.session_processor
        end

        def routes
          self.class.routes
        end

        sig ['Charyf::Engine::Context'], nil,
        def spawn_controller(context)

          Charyf.logger.flow_request("[FLOW] Dispatching request [#{context.request.inspect}]" +
                                      ", detected intent: [#{context.intent.inspect}]" +
                                      ", session : [#{context.session.inspect}]"
          )

          controller = get_controller(context)

          begin
            handle_before_actions(controller)
            result = controller.send(get_action_name(context))
            handle_after_actions(controller)

            # TODO collect all replies
            return :OK, result
          rescue Exception => e
            # Dispatch the error to all error handlers
            Charyf.configuration.error_handlers.handle_exception(e)
            # Catch any error that may occur inside the user controller
            # controller.send(:reply, text: 'There was a problem processing your request. Check the logs please.')

            return :NOK, e
          end

        end

        private

        def get_controller(context)
          controller_name = context.routing.controller_class_name

          # Object.const_get(controller_name).new(context)
          controller_name.constantize.new(context)
        end

        def get_action_name(context)
          context.routing.action
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
    end
  end
end