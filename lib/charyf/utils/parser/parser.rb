require_relative '../../support/string'
require_relative '../strategy'

module Charyf
  module Utils
    module Parser
      class Base

        include Charyf::Strategy
        def self.base
          Base
        end

        # TODO sig
        def self.normalize(text, remove_articles: true)
          raise Charyf::Utils::NotImplemented.new
        end

      end # End of base

      def self.known
        Base.known
      end

      def self.list
        Base.list
      end

      # TODO sig
      def self.get(language)
        # TODO implement
        Charyf::Utils::Parser::English
        list[language]
      end
    end
  end
end