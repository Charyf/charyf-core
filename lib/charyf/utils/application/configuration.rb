require_relative '../app_engine'
require_relative '../extension/configuration'

module Charyf
  class Application < AppEngine
    class Configuration < Extension::Configuration

      attr_reader :root

      attr_accessor :console

      attr_accessor :session_processor, :storage_provider, :dispatcher
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

      sig [], ['Symbol', 'NilClass'],
      def dispatcher
        (@dispatcher || 'default').to_sym
      end

      sig [], ['Symbol'],
      def session_processor
        (@session_processor || 'default').to_sym
      end

      sig [], [Array],
      def enabled_intent_processors
        (@enabled_intent_processors || []).map(&:to_sym)
      end

      sig [], ['Symbol', 'NilClass'],
      def storage_provider
        @storage_provider ? @storage_provider.to_sym : nil
      end

    end
  end
end