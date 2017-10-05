require 'charyf/utils'
require_relative '../request'

module Charyf
  module Engine
    class Intent
      class DummyProcessor

        sig [Charyf::Engine::Request], Charyf::Engine::Intent,
        def process(request)
          Charyf::Engine::Intent::UNKNOWN
        end

      end
    end
  end
end

Charyf::Strategy.add_intent_processor :base, Charyf::Engine::Intent::DummyProcessor