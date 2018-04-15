# frozen_string_literal: true

require_relative 'extension'
require_relative 'app_engine/extensions'

module Charyf
  class AppEngine < Extension

    # Load Charyf generators and invoke the registered hooks.
    # Check <tt>Charyf::Extension.generators</tt> for more info.
    def load_generators(app = self)
      require_relative 'generators'
      Charyf::Generators.configure!(app.config.generators)

      require_relative 'generators/app/app_generator'
      require_relative 'generators/skill/skill_generator'
      require_relative 'generators/intents/intents_generator'

      run_generators_blocks(app)
      self
    end

    def start_interfaces
      Charyf.application.interfaces.map(&:start)
    end

    def start_pipeline

      begin
        loop do
          request = Charyf::Pipeline.dequeue

          Charyf.application.dispatcher.new.dispatch(request)
        end

      rescue Exception => e
        if e.is_a? Interrupt
          puts "\n\nExiting ...\n"
        elsif e.message =~ /No live threads left./
          raise "No interfaces are available. The server will now exit."
        else
          puts e
          puts e.backtrace
          Charyf.application.config.error_handlers.handle_exception(e)
          raise e
        end
      end

    end

  end
end