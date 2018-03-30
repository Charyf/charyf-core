require_relative '../../utils'

require_relative '../response'
require_relative '../dispatcher/base'

module Charyf
  module Interface

    extend Charyf::Strategy::OwnerClass

    class Base

      include Charyf::Strategy::BaseClass

      class << self

        def dispatcher
          Charyf.application.dispatcher.new
        end

        def reply(conversation_id, message_id, response)
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
  end
end