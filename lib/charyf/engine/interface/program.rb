require 'securerandom'

require_relative 'interface'
require_relative '../request'

module Charyf
  module Interface
    class Program < Charyf::Interface::Base

      class InvalidConversationError < StandardError; end

      strategy_name :program

      attr_reader :handler, :conversation_id

      def self.start
        # NOP
      end

      def self.stop
        # NOP
      end

      def self.terminate
        # NOP
      end

      def self.reply(conversation_id, message_id, response)
        interface = _interfaces[conversation_id]
        raise InvalidConversationError.new("No program interface found for conversation #{conversation_id}") unless interface

        interface.reply(response)
      end

      def self.create(conversation_id, handler)
        interface = self.new(conversation_id, handler)

        _interfaces[conversation_id] = interface

        interface
      end

      def self._interfaces
        @_interfaces ||= Hash.new
      end

      def initialize(conversation_id, handler)

        @handler = handler
        @conversation_id = conversation_id.to_s
      end

      def process(request)
        self.class.dispatcher.dispatch(request)
      end

      def reply(response)
        handler.call(response)
      end

      def request
        Charyf::Engine::Request.new(self.class, conversation_id, SecureRandom.hex)
      end

    end
  end
end