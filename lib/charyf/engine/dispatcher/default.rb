require_relative 'base'

module Charyf
  module Engine
    module Dispatcher
      class BaseDispatcher < Base

        strategy_name :default

        def dispatch_internal(request)
          # Find if session exist for this request

          context = Charyf::Engine::Context.new
          context.request = request

          # TODO process session as well
          context.session = session_processor.get.process(request)

          # Get intents
          intents = intent_processors.collect do |processor_klass|
            processor = processor_klass.instance

            processor.determine(
                request
            )
          end.flatten.sort_by do |intent|
            intent.confidence
          end.reverse

          # Sort by confidence
          best_match = intents.shift

          # Return best match with alternatives
          if best_match
            context.intent = best_match
            context.alternative_intents = intents
          end

          context.routing = routes.process(context)

          # Freeze -> #TODO deep freeze
          context.freeze

          spawn_controller(context)
        end

      end
    end
  end
end
