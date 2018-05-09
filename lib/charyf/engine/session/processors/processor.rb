require_relative '../../../utils'

module Charyf
  module Engine
    class Session
      module Processor

        extend Charyf::Strategy::OwnerClass

        class Base

          include Charyf::Strategy::BaseClass

          def process(request)
            raise Charyf::Utils::NotImplemented.new
          end

          def self.get
            raise Charyf::Utils::NotImplemented.new
          end

        end
      end
    end
  end
end
