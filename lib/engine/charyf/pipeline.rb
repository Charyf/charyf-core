module Charyf
  module Engine
    class Pipeline

      sig [Charyf::API::Request],
      def dispatch(request)
        # TODO

      end

      private

      sig [Charyf::Engine::Context],
      def spawn_controller(context)


        # TODO
        controller_name = 'Application' + 'Controller'
        action_name = 'unknown'


        controller = Object.const_get(controller_name).new(context.request, context.intent, context.session)

        begin
          controller.send(action_name)
        rescue Exception => e
          # Catch any error that may occur inside the user controller
          controller.reply(text: 'There was a problem processing your request. Check the logs please.')

          # Dispatch the error to all error handlers
          Charyf.configuration.error_handlers.handle_exception(e)
        end
      end

    end
  end
end