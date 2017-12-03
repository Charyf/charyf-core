require 'charyf/utils'
require_relative 'processor'

module Charyf
  module Engine
    class Session
      module Processor
        class Dummy < Base

          strategy_name :dummy

          def process(request)
            nil
          end

          def self.get
            self.new
          end

        end
      end
    end
  end
end