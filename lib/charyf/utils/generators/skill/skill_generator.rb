# frozen_string_literal: true

require_relative '../named_base'

require_relative '../../../support'

module Charyf
  module Generators
    class SkillGenerator < NamedBase # :nodoc:

      check_class_collision
      check_class_collision suffix: '::BaseController'

      def create_module_file
        return if class_path.empty?
        template 'module.rb', File.join('app/skills', module_path.join('/'), "#{module_file_name}.rb") if behavior == :invoke
      end

      def create_skill_file
        template 'skill.rb', File.join('app/skills', class_path, "#{file_name}.rb")
      end

      def controller
        empty_directory File.join('app/skills', skill_content_path, 'controllers')

        template 'controllers/skill_controller.rb', File.join('app/skills', skill_content_path, 'controllers', "#{file_name}_controller.rb")
      end

      def intents
        empty_directory File.join('app/skills', skill_content_path, 'intents')
      end

      def responses
        empty_directory File.join('app/skills', skill_content_path, 'responses')

        empty_directory File.join('app/skills', skill_content_path, 'responses', file_name)
      end

      def initializers
        empty_directory File.join('app/skills', skill_content_path, 'initializers')
      end

      hook_for :intents

    end
  end
end
