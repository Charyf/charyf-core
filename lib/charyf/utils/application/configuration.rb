module Charyf
  class Application
    class Configuration

      attr_reader :root
      attr_accessor :session_processor
      attr_accessor :enabled_intent_processors

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
        (@session_processor || 'dummy').to_s
      end

      sig [], [Array],
      def enabled_intent_processors
        (@enabled_intent_processors || []).map(&:to_sym)
      end

    end
  end
end