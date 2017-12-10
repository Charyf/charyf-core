module Charyf
  module Engine
    class Request

      attr_accessor :text

      # Module -> anything of type Charyf::Interface::Base
      sig ['Module', 'String'], nil,
      def initialize(referer, conversation_id)
        @referer = referer
        @conversation_id = conversation_id
      end

      # Module -> Charyf::Interface::Base
      sig [], 'Module',
      def referer
        @referer
      end

      sig [], 'String',
      def conversation_id
        @conversation_id
      end

      sig [], 'String',
      def id
        @referer.strategy_name.to_s + '_#_' + @conversation_id
      end

    end
  end
end