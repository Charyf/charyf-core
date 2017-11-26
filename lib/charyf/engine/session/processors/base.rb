require 'charyf/utils'

module Charyf
  module Engine
    class Session
      module Processors
        class Base

          include Charyf::Strategy
          def self.base
            Base
          end


          sig ['Charyf::Engine::Request'], ['Charyf::Engine::Session', 'NilClass'],
          def process(request)
            raise Charyf::Utils::NotImplemented.new
          end

        end


        def self.known
          Base.known
        end

        def self.list
          Base.list
        end

      end
    end
  end
end
