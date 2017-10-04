require 'charyf/utils'

require_relative '../response'
require_relative '../dispatcher'

module Charyf
  module Interface
    class Base

      sig [], Charyf::Engine::Dispatcher,
      def dispatcher
        Charyf.dispatcher
      end

      sig [Charyf::Engine::Response], nil,
      def reply(response)
        raise Charyf::Tools::NotImplemented.new
      end

    end
  end
end