require_relative '../../../utils'

module Charyf
  module Engine
    class Session
      module Processor
        class Base

          include Charyf::Strategy
          def self.base
            Base
          end


          sig ['Charyf::Engine::Request'], ['Charyf::Engine::Session', 'NilClass'],
          def process(request)
            raise Charyf::Utils::NotImplemented.new
          end

          sig_self [], ['Charyf::Engine::Session::Processor::Base'],
          def self.get
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
