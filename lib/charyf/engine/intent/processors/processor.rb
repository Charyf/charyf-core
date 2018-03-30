require_relative '../../../utils'

require_relative 'helpers'
require_relative '../intent'

module Charyf
  module Engine
    class Intent
      module Processor

        extend Charyf::Strategy::OwnerClass

        class Base

          include Charyf::Strategy::BaseClass
          include Charyf::Engine::Intent::Processor::Helpers

          def self.instance
            @instance = self.new
          end

          def determine(request)
            raise Charyf::Utils::NotImplemented.new
          end

        end
      end
    end
  end
end
