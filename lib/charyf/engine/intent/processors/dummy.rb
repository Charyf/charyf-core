require 'charyf/utils'
require_relative '../intent'
require_relative 'processor'

module Charyf
  module Engine
    class Intent
      module Processor
        class Dummy < Base

          strategy_name :dummy

          def self.get_for(skill_name = nil)
            self.new
          end

          def determine(request)
            unknown
          end

          def load(skill_name, block)
            nil
          end

        end
      end
    end
  end
end