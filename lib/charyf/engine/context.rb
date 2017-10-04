module Charyf
  module Engine
    class Context

      sig [Charyf::Engine::Context],Charyf::Engine::Context,
      def request=(request)
        @_request = request
      end

      sig [], Charyf::Engine::Context,
      def request
        @_request
      end

      sig [Charyf::Engine::Intent],Charyf::Engine::Intent,
      def intent=(intent)
        @_intent = intent
      end

      sig [], Charyf::Engine::Intent,
      def intent
        @_intent
      end

      sig [Charyf::Engine::Session],Charyf::Engine::Session,
      def session=(session)
        @_session = session
      end

      sig [], Charyf::Engine::Session,
      def session
        @_session
      end

    end
  end
end