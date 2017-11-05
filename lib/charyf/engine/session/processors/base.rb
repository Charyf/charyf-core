require 'charyf/utils'

module Charyf
  module Engine
    class Session
      module Processors
        class Base

          class << self

            def inherited(subclass)
              Base._subclasses[subclass.name.demodulize.underscore] = subclass
            end

            def _subclasses
              @_subclasses ||= Hash.new
            end

          end


          sig ['Charyf::Engine::Request'], ['Charyf::Engine::Session', 'NilClass'],
          def process(request)
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
