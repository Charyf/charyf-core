require 'charyf/utils'
require_relative '../intent'

module Charyf
  module Engine
    class Intent
      module Processors
        class Base

          class << self

            def inherited(subclass)
              _subclasses[subclass.name.demodulize] = subclass
            end

            def _subclasses
              @_subclasses ||= Hash.new
            end

          end

          sig ['Charyf::Engine::Request', ['String', 'Symbol', 'NilClass']], 'Charyf::Engine::Context',
          def process(request, skill = nil)
            raise Charyf::Tools::NotImplemented.new
          end

        end

        def self.list
          Base._subclasses
        end

      end
    end
  end
end
