require_relative 'result'

module Charyf
  module Engine
    module Routing

      extend Charyf::Strategy::OwnerClass

      class Base

        include Charyf::Strategy::BaseClass

        def draw(&block)
          raise Charyf::Utils::NotImplemented.new
        end

        # Context -> Controller
        def process(context)
          raise Charyf::Utils::NotImplemented.new
        end

        def unknown
          Result.new(nil, 'skill', 'unknown')
        end

        def invalid
          Result.new(nil, 'skill', 'invalid')
        end

      end
    end
  end
end