module Charyf
  module Engine
    class Intent

      attr_reader :name, :confidence, :entities

      def initialize(name, confidence, entities = Hash.new)
        @name = name
        @confidence = confidence
        @entities = entities || {}
      end

      def self.unknown
        Intent.new('charyf/unknown', 0)
      end

    end
  end
end
