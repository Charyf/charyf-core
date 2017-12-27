module Charyf
  module Configuration

    class Generators #:nodoc:
      attr_reader :hidden_namespaces

      def initialize
        @hidden_namespaces = []
      end

      def hide_namespace(namespace)
        @hidden_namespaces << namespace
      end
    end
  end
end