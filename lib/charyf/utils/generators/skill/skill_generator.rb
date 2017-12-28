# frozen_string_literal: true

require_relative '../app_base'
require_relative '../../../support'

module Charyf
  module Generators
    class SkillGenerator < Base # :nodoc:

      argument :skill_name, type: :string

      def skill
        template 'skill.rb', "#{file_name}.rb"
      end

      def controller
        empty_directory 'controllers'

        inside 'controllers' do
          template 'skill_controller.rb', "#{file_name}_controller.rb"
        end
      end

      def intents
        empty_directory 'intents'
      end

      def responses
        empty_directory 'responses'

        inside 'responses' do
          empty_directory file_name
        end
      end


      hook_for :intents

      private

      def file_name
        skill_name.demodulize.downcase
      end


    end
  end
end
