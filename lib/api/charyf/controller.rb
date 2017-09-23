module Charyf
  module Controller
    class Base

      def initialize(request, intent, session)
        @request = request
        @intent = intent
        @session = session
      end

      def unknown
        reply text: 'Unknown action'
      end

    end
  end
end