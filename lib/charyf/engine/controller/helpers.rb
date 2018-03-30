module Charyf
  module Controller
    module Helpers

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
      end # End of ClassMethods

      def controller_name
        context.routing.controller
      end

      def action_name
        context.routing.action
      end

      def skill_name
        skill.skill_name
      end

      def skill
        context.routing.skill_class_name.nil? ? nil : context.routing.skill_class_name.constantize
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
