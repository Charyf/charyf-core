module Charyf
  module Engine
    class Request

      attr_accessor :text

      attr_reader :referer, :conversation_id, :message_id


      # Module -> anything of type Charyf::Interface::Base
      def initialize(referer, conversation_id, message_id)
        @referer = referer
        @conversation_id = conversation_id
        @message_id = message_id
      end

    end
  end
end