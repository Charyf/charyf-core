module Charyf
  module Engine
    class Intent

      sig [[Symbol, String], [Symbol, String], Numeric, Array], nil,
      def initialize(controller, action, confidence, matches = Hash.new)
        @_controller = controller
        @_action = action
        @_confidence = confidence
        @_matches = matches
        @_alternatives = []
      end

      sig [], Hash,
      def matches
        @_matches
      end

      sig [], Numeric,
      def confidence
        @_confidence
      end

      sig [], [Symbol, String],
      def controller
        @_controller
      end

      sig [], [Symbol, String],
      def action
        @_action
      end

      sig [], Array,
      def alternatives
        @_alternatives
      end

      UNKNOWN = Intent.new(:Application, :unknown, 100)

    end
  end
end
