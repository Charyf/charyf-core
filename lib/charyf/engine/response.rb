module Charyf
  module Engine
    class Response

      attr_accessor :text

      sig [String], String,
      def text=(text)
        @_text = text
      end

      sig [], String,
      def text
        @_text
      end

    end
  end
end