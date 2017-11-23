require 'charyf/utils'

require_relative '../response'
require_relative '../dispatcher/base'

module Charyf
  module Interface
    class Base

      sig [], 'Charyf::Engine::Dispatcher::Base',
      def dispatcher
        Charyf.application.dispatcher
      end

      sig ['Charyf::Engine::Response'], nil,
      def reply(response)
        raise Charyf::Tools::NotImplemented.new
      end

    end
  end
end