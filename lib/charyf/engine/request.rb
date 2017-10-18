module Charyf
  module Engine
    class Request

      attr_accessor :text

      sig ['Charyf::Interface::Base', 'String'], nil,
      def initialize(referer, conversation_id)
        @referer = referer
        @conversation_id = conversation_id
      end

      sig [], 'Charyf::Interface::Base',
      def referer
        @referer
      end

      sig [], 'String',
      def conversation_id
        @conversation_id
      end

    end
  end
end