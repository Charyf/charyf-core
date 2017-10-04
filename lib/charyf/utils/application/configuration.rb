module Charyf
  class Application
    class Configuration

      attr_reader :root

      def initialize(root)

        @root = root

      end

      def error_handlers
        Charyf::ErrorHandlers
      end


    end
  end
end