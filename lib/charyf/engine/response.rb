module Charyf
  module Engine
    class Response

      attr_accessor :text

      # Attr methods for type-checking

      sig ['String'], 'String',
      def text=(text)
        @text = text
      end

      sig [], 'String',
      def text
        @text
      end

    end
  end
end