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

      sig [{text: String}], nil,
      def reply(text:)
        response = Charyf::Engine::Response.new

        response.text = text

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