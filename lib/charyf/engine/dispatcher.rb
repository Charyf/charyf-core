require_relative 'context'
require_relative 'request'

module Charyf
  module Engine
    class Dispatcher

      sig ['Charyf::Engine::Request'], nil,
      def dispatch(request)
        # Find if session exist for this request

        context = Charyf::Engine::Context.new
        context.request = request

        # TODO process session as well

        context.session = Charyf.application.session_processor.process(request)

        context.intent = intent_processor.determine(
            request,
            context.session ? context.session.skill : nil
        )

        # TODO
        spawn_controller(context)
      end

      private

      def intent_processor
        Charyf.application.intent_processors.first
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
  end
end