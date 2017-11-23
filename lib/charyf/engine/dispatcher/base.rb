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

          intent = context.intent || Charyf::Engine::Intent::UNKNOWN

          controller_name = intent.controller + 'Controller'
          action_name = intent.action

          controller = Object.const_get(controller_name).new(context.request, intent, context.session)

          # TODO log intent when done
          Charyf.flow_logger.info("Dispatching request [#{context.request.referer.class}" +
                                      "|#{context.request.conversation_id}" +
                                      "|#{context.request.text}]" +
                                      " to #{controller_name}##{action_name}"
          )

          begin
            controller.send(action_name)
          rescue Exception => e
            # Catch any error that may occur inside the user controller
            controller.send(:reply, text: 'There was a problem processing your request. Check the logs please.')

            # Dispatch the error to all error handlers
            Charyf.configuration.error_handlers.handle_exception(e)
          end

        end

      end

      def self.known
        Base.known
      end

      def self.list
        Base.list
      end

    end
  end
end