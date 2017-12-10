require 'charyf/utils'

require_relative '../response'
require_relative '../dispatcher/base'

module Charyf
  module Interface
    class Base

      include Charyf::Strategy
      def self.base
        Base
      end

      sig_self [], 'Charyf::Engine::Dispatcher::Base',
      def self.dispatcher
        Charyf.application.dispatcher.new
      end

      sig_self ['String', 'Charyf::Engine::Response'], nil,
      def self.reply(conversation_id, response)
        raise Charyf::Utils::NotImplemented.new
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