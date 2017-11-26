require 'charyf/utils'
require_relative '../intent'
require_relative 'processor'

module Charyf
  module Engine
    class Intent
      module Processor
        class Dummy < Base

          strategy_name :dummy
          definition_extension :dummy

          def determine(request, skill = nil)
            unknown
          end

        end
      end
    end
  end
end