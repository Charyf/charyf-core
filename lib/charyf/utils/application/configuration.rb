module Charyf
  class Application
    class Configuration

      attr_reader :root
      attr_accessor :session_processor, :intent_processor, :speech_processor

      def initialize(root)

        @root = root

      end

      def i18n
        I18n
      end

      def error_handlers
        Charyf::ErrorHandlers
      end

      sig [], ['String'],
      def session_processor
        @session_processor || 'Dummy'
      end

      sig [], ['String'],
      def intent_processor
        @intent_processor || 'Dummy'
      end

    end
  end
end