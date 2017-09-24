require_relative 'context'

module Charyf
  module Engine
    class Dispatcher

      sig [Charyf::API::Request],
      def dispatch(request)
        # Find if session exist for this request

        context = Charyf::Engine::Context.new
        context.request = request

        # TODO
        spawn_controller(context)
      end

      private

      def spawn_controller(context)


        # TODO
        controller_name = 'Charyf::Controller::Base'
        # controller_name = 'Application' + 'Controller'
        action_name = 'unknown'

        controller = Object.const_get(controller_name).new(context.request, context.intent, context.session)

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