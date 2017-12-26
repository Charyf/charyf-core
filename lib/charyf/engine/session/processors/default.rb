require_relative '../../../utils'

require_relative '../session'
require_relative 'processor'

module Charyf
  module Engine
    class Session
      module Processor
        class Default < Base

          # 10 Minute
          # TODO - move to config?
          SESSION_TIMEOUT = 10 * 60

          strategy_name :default

          def process(request)
            # session = Charyf::Engine::Session.get(request.id)
            #
            # return unless session
            #
            # if session && Time.now - session.timestamp > SESSION_TIMEOUT
            #   session.destroy!
            #   return nil
            # end
            #
            # session.invalidate!
            # session

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