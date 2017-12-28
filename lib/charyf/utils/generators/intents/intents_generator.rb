# frozen_string_literal: true

require_relative '../app_base'

require_relative '../../generators'

require_relative '../../../support'

module Charyf
  module Generators
    class IntentsGenerator < Base # :nodoc:

      argument :skill_name, type: :string

      def try
        intent_generators.each do |name|
          names = generator_name(name).to_s.split(":")
          klass = Charyf::Generators.find_by_namespace(names.pop, names.any? && names.join(":"))
          if klass
            say_status behavior, generator_name(name), :green
            Charyf::Generators.invoke generator_name(name), [skill_name], behavior: behavior
          else
            say_status behavior, "#{generator_name(name)} generator not found", :red
          end
        end
      end

      private

      def intent_generators
        Charyf::Generators.options[:charyf][:enabled_intents]
      end

      def generator_name(intent_processor_name)
        "#{intent_processor_name}:intent"
      end

    end
  end
end
