require_relative '../response'

module Charyf
  module Controller
    class Base

      attr_reader :request, :intent, :session

      def initialize(request, intent, session)
        @request = request
        @intent = intent
        @session = session
      end

      def unknown
        reply text: "I don't know what you meant by '#{request.text}'"
      end


      protected

      sig [{text: ['String','NilClass'], render: ['Symbol', 'String', 'NilClass']}], nil,
      def reply(text: nil, render: nil)
        response = Charyf::Engine::Response.new

        response.text = text || "" # TODO

        Charyf.flow_logger.info("Replying on request [#{request.referer.class}" +
                                    "|#{request.conversation_id}" +
                                    "|#{request.text}]" +
                                    " with |#{text}|"
        )

        request.referer.reply(response)
      end

    end
  end
end