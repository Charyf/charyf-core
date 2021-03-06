# frozen_string_literal: true

require_relative '../app_base'
require_relative '../named_base'

require_relative '../../generators'

require_relative '../../../support'

module Charyf
  module Generators
    class SkillHooksGenerator < NamedBase # :nodoc:

      def try
        hooked_generators.each do |generator_name|
          names = generator_name.to_s.split(":")
          klass = Charyf::Generators.find_by_namespace(names.pop, names.any? && names.join(":"))

          if klass
            say_status behavior, generator_name, :green

            invoke generator_name, [name], options, behavior: behavior
          else
            say_status behavior, "#{generator_name} generator not found", :red
          end
        end
      end

      private

      def hooked_generators
        (Charyf::Generators.options[:skill_hooks] || []).compact.map(&:downcase)
      end

    end
  end
end
