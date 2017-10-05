module Charyf
  class Application
    class Configuration

      attr_reader :root
      attr_accessor :session_processor, :intent_processor, :speech_processor

      def initialize(root)

        @root = root

      end

      def error_handlers
        Charyf::ErrorHandlers
      end

      sig [], Symbol,
      def session_processor
        @session_processor || :base
      end

      sig [], Symbol,
      def intent_processor
        @intent_processor || :base
      end

    end
  end
end