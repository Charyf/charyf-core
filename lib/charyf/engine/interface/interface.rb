require_relative '../../utils'

require_relative '../response'
require_relative '../dispatcher/base'

module Charyf
  module Interface
    class Base

      include Charyf::Strategy

      class << self
        def base
          Base
        end

        def dispatcher
          Charyf::Pipeline
        end

        def reply(conversation_id, response)
          raise Charyf::Utils::NotImplemented.new
        end

        def start
          raise Charyf::Utils::NotImplemented.new
        end

        def stop
          raise Charyf::Utils::NotImplemented.new
        end

        # If stop does not finish till required timeout
        # Terminate is called
        def terminate
          raise Charyf::Utils::NotImplemented.new
        end
      end

    end

    def self.known
      Base.known
    end

    def self.list
      Base.list
    end
  end
end