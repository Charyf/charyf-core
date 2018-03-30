require_relative '../../../utils'

module Charyf
  module Engine
    class Session
      module Processor

        extend Charyf::Strategy::OwnerClass

        class Base

          include Charyf::Strategy::BaseClass

          sig ['Charyf::Engine::Request'], ['Charyf::Engine::Session', 'NilClass'],
          def process(request)
            raise Charyf::Utils::NotImplemented.new
          end

          sig_self [], ['Charyf::Engine::Session::Processor::Base'],
          def self.get
            raise Charyf::Utils::NotImplemented.new
          end

        end
      end
    end
  end
end
