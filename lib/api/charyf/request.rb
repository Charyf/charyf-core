require_relative 'interface/base'

module Charyf
  module API
    class Request

      attr_reader :referer, :conversation_id
      attr_accessor :text

      sig [Charyf::API::Interface::Base, String],
      def initialize(referer, conversation_id)
        @referer = referer
        @conversation_id = conversation_id
      end

    end
  end
end