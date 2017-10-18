require 'charyf/utils'
require_relative 'base'

module Charyf
  module Engine
    class Session
      module Processors
        class Dummy < Base

          def process(request)
            nil
          end

        end
      end
    end
  end
end