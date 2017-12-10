module Charyf
  module Engine
    class Context

      sig ['Charyf::Engine::Request'],'Charyf::Engine::Request',
      def request=(request)
        @_request = request
      end

      sig [], 'Charyf::Engine::Request',
      def request
        @_request
      end

      sig [['Charyf::Engine::Intent', 'NilClass']],['Charyf::Engine::Intent', 'NilClass'],
      def intent=(intent)
        @_intent = intent
      end

      sig [], ['Charyf::Engine::Intent', 'NilClass'],
      def intent
        @_intent
      end

      sig [['Charyf::Engine::Session', 'NilClass']],['Charyf::Engine::Session', 'NilClass'],
      def session=(session)
        @_session = session
      end

      sig [], ['Charyf::Engine::Session', 'NilClass'],
      def session
        @_session
      end

      def controller_name
        session && session.action ?
            session.controller :
            intent.controller
      end

      def full_controller_name
        session && session.action ?
            session.full_controller_name :
            intent.full_controller_name
      end

      def action_name
        session && session.action ?
            session.action :
            intent.action
      end

      def skill_name
        session && session.skill ?
            session.skill :
            intent.skill
      end

    end
  end
end