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

      sig_self ['String', 'Charyf::Engine::Response'], nil,
      def self.reply(conversation_id, response)
        interface = _interfaces[conversation_id]
        raise InvalidConversationError.new("No program interface found for conversation #{conversation_id}") unless interface

        interface.reply(response)
      end

      sig_self ['String', 'Proc'], 'Charyf::Interface::Program',
      def self.create(conversation_id, handler)
        interface = self.new(conversation_id, handler)

        _interfaces[conversation_id] = interface

        interface
      end

      def self._interfaces
        @_interfaces ||= Hash.new
      end

      sig [nil, 'Proc'],
      def initialize(conversation_id, handler)

        @handler = handler
        @conversation_id = conversation_id.to_s
      end

      sig ['Charyf::Engine::Request'],
      def process(request)
        self.class.dispatcher.dispatch(request)
      end

      sig ['Charyf::Engine::Response'],
      def reply(response)
        handler.call(response)
      end

      sig [], 'Charyf::Engine::Request',
      def request
        Charyf::Engine::Request.new(self.class, conversation_id)
      end

    end
  end
end