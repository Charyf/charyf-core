require_relative 'base'
require_relative '../request'

module Charyf
  module Interface
    class Program < Charyf::Interface::Base

      attr_reader :handler, :conversation_id

      sig [nil, Proc],
      def initialize(conversation_id, handler)

        @handler = handler
        @conversation_id = conversation_id.to_s
      end

      sig [Charyf::Engine::Request],
      def process(request)
        dispatcher.dispatch(request)
      end

      sig [Charyf::Engine::Response],
      def reply(response)
        handler.call(response)
      end

      sig [], Charyf::Engine::Request,
      def request
        Charyf::Engine::Request.new(self, conversation_id)
      end

    end
  end
end