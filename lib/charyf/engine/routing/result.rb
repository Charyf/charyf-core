module Charyf
  module Engine
    module Routing
      class Result

        attr_reader :skill, :controller, :action

        def initialize(skill, controller, action)
          @skill = skill
          @controller = controller
          @action = action
        end

        def controller_class_name
          [skill, controller.split("/")].flatten.compact.map(&:to_s).map(&:camelize).join("::") + "Controller"
        end

        def skill_class_name
          skill.to_s.camelize if skill
        end

      end
    end
  end
end