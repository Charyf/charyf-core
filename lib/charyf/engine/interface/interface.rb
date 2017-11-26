require 'charyf/utils'

require_relative '../response'
require_relative '../dispatcher/base'

module Charyf
  module Interface
    class Base

      sig [], 'Charyf::Engine::Dispatcher::Base',
      def dispatcher
        Charyf.application.dispatcher.new
      end

      sig ['Charyf::Engine::Response'], nil,
      def reply(response)
        raise Charyf::Utils::NotImplemented.new
      end

    end
  end
end