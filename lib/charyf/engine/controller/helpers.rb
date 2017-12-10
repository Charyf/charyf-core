module Charyf
  module Controller
    module Helpers

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
      end # End of ClassMethods

      def controller_name
        context.controller_name
      end

      def action_name
        context.action_name
      end

      def skill_name
        context.skill_name
      end

      def request
        context.request
      end

      def session
        context.session
      end

      def intent
        context.intent
      end

    end
  end
end
