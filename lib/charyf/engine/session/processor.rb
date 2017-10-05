require 'charyf/utils'

module Charyf
  module Engine
    class Session
      class DummyProcessor

        sig [Charyf::Engine::Request], Array,
        def process(request)
          [nil, nil]
        end

      end
    end
  end
end

Charyf::Strategy.add_session_processor :base, Charyf::Engine::Session::DummyProcessor