require 'securerandom'

require_relative '../../utils'

require_relative '../response'
require_relative 'renderers'
require_relative 'conversation'
require_relative 'helpers'
require_relative 'actions'

module Charyf
  module Controller
    class Base

      include Renderers
      include Helpers
      include Actions

      attr_reader :context

      def initialize(context)
        @context = context
      end

      def unknown
        reply text: "I don't know what you meant by '#{request.text}'"
      end

      protected

      def reply(
          text: nil,
          html: nil,
          render: nil
      )

        if text.blank? && html.blank?
          render ||= action_name
          ensure_responses_for(render)
        end

        if response_folder
          text ||= render_text_response(render)
          html ||= render_html_response(render)
        end

        response = Charyf::Engine::Response.new(conversation_id, SecureRandom.hex)
        response.text = text
        response.html = html

        Charyf.logger.flow_response("[FLOW] Replying on request [#{request.inspect}]" +
                                    " with [#{response.inspect}]"
        )

        request.referer.reply(conversation_id, request.message_id, response)

        return response
      end

      def conversation_id
        request.conversation_id
      end

    end
  end
end