module Charyf
  module Engine
    class Intent

      sig [['Symbol', 'String', 'NilClass'], ['Symbol', 'String'], ['Symbol', 'String'], 'Numeric', 'Hash', 'Array'], nil,
      def initialize(skill, controller, action, confidence, matches = Hash.new, alternatives = [])
        @_skill = skill.to_s
        @_controller = controller.to_s
        @_action = action.to_s.downcase
        @_confidence = confidence
        @_matches = matches
        @_alternatives = alternatives
      end

      sig [], 'Hash',
      def matches
        @_matches
      end

      sig [], 'Numeric',
      def confidence
        @_confidence
      end

      sig [], ['Symbol', 'String'],
      def full_controller_name
        @_skill.blank? ? @_controller.camelize : @_skill.camelize + '::' + @_controller.camelize
      end

      sig [], ['Symbol', 'String'],
      def controller
        @_controller
      end

      sig [], ['Symbol', 'String'],
      def action
        @_action
      end

      sig [], 'Array',
      def alternatives
        @_alternatives
      end

      sig [], ['String', 'Symbol'],
      def skill
        @_skill
      end

      UNKNOWN = Intent.new(nil, :Application, :unknown, 0)

    end
  end
end
