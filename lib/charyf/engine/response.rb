module Charyf
  module Engine
    class Response

      attr_accessor :text, :html
      attr_reader :conversation_id, :reply_message_id

      def initialize(conversation_id, reply_message_id)
        @text = nil
        @html = nil

        @conversation_id = conversation_id
        @reply_message_id = reply_message_id
      end

      def empty?
        text.blank? && html.blank?
      end

    end
  end
end