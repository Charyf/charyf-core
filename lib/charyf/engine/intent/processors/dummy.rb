require 'charyf/utils'
require_relative '../intent'

module Charyf
  module Engine
    class Intent
      module Processors
        class Dummy < Base

        def determine(request, skill = nil)
            unknown
          end

        end
      end
    end
  end
end