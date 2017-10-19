require_relative '../string'

module Charyf
  module Utils
    module Parser
      class Base

        class << self

          def inherited(subclass)
            Base._subclasses[subclass.name.demodulize] = subclass
          end

          def _subclasses
            @_subclasses ||= Hash.new
          end

        end

        # TODO sig
        def self.normalize(text)
          raise Charyf::Tools::NotImplemented.new
        end

      end

      # TODO sig
      def self.get(language)
        # TODO implement
        Charyf::Parser::English
        # Base._subclasses[language]
      end
    end
  end
end