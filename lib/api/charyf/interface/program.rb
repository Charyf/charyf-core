require_relative 'base'
require_relative '../request'

module Charyf
  module API
    module Interface
      class Program < Charyf::API::Interface::Base

        attr_reader :handler, :conversation_id

        sig [nil, Proc],
        def initialize(conversation_id, handler)

          @handler = handler
          @conversation_id = conversation_id.to_s
        end

        def request
          Charyf::API::Request.new(self, conversation_id)
        end

        def process(request)
          dispatcher.dispatch(request)
        end

        def reply(response)
          handler.call(response)
        end

      end
    end
  end
end