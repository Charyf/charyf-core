require_relative '../../support/string'
require_relative '../strategy/base_class'
require_relative '../strategy/owner_class'

module Charyf
  module Utils
    module Parser

      extend Charyf::Strategy::OwnerClass

      class Base

        include Charyf::Strategy::BaseClass

        # TODO sig
        def self.normalize(text, remove_articles: true)
          raise Charyf::Utils::NotImplemented.new
        end

      end # End of base

      # TODO sig
      def self.get(language)
        # TODO implement
        Charyf::Utils::Parser::English
        list[language]
      end
    end
  end
end