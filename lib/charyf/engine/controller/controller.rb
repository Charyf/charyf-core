require_relative '../response'
require_relative 'renderers'
require 'charyf/utils'

module Charyf
  module Controller
    class Base

      include Renderers

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
      def reply(
          text: nil,
          html: nil,
          render: nil
      )


        if text.blank? && html.blank?
          render ||= @intent.action

          if response_folder.blank?
            raise Charyf::Controller::Renderers::InvalidState.new('Controller without skill can not render views')
          end

          if responses_for(render).empty?
            raise Charyf::Controller::Renderers::NoResponseFound.new('No responses files found for action' + render.to_s + "\n" +
            "Expected #{render}.[html|txt].erb in #{response_folder}")
          end
        end

        if response_folder
          text ||= render_text_response(render)
          html ||= render_html_response(render)
        end

        response = Charyf::Engine::Response.new(text, html)


        Charyf.logger.flow_response("[FLOW] Replying on request [#{request.inspect}]" +
                                    " with [#{response.inspect}]"
        )

        request.referer.reply(response)
      end

    end
  end
end