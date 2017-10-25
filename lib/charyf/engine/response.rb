module Charyf
  module Engine
    class Response

      attr_accessor :text, :html

      sig [['String', 'NilClass'], ['String', 'NilClass']], nil,
      def initialize(text, html)
        @text = text
        @html = html
      end

      def empty?
        text.blank? && html.blank?
      end

      # Attr methods for type-checking

      sig ['String', 'NilClass'], ['String', 'NilClass'],
      def text=(text)
        @text = text
      end

      sig [], ['String', 'NilClass'],
      def text
        @text
      end

      sig ['String', 'NilClass'], ['String', 'NilClass'],
      def html=(html)
        @html = html
      end

      sig [], ['String', 'NilClass'],
      def html
        @html
      end

    end
  end
end