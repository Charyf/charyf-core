require_relative '../../../utils'

require_relative '../intent'
require_relative 'processor'

module Charyf
  module Engine
    class Intent
      module Processor
        class Dummy < Base

          strategy_name :dummy

          def determine(request)
            unknown
          end

        end
      end
    end
  end
end