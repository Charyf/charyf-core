# frozen_string_literal: true

require_relative '../generator/base'

module Charyf
  module Generators
    class NamedBase < Base
      argument :name, type: :string

      def initialize(args, *options) #:nodoc:
        # Unfreeze name in case it's given as a frozen string
        args[0] = args[0].dup if args[0].is_a?(String) && args[0].frozen?
        super
        assign_names!(name)
      end

      private

      def class_path # :doc:
        @class_path
      end

      def module_path
        class_path[0...-1]
      end

      def module_file_name
        class_path.last
      end

      def file_name
        @file_name
      end

      def skill_content_path
        class_path.dup.push(file_name)
      end

      def empty_directory_with_keep_file(destination, config = {})
        empty_directory(destination, config)
        create_file("#{destination}/.keep")
      end

      def class_name # :doc:
        (class_path + [file_name]).map!(&:camelize).join("::")
      end

      def assign_names!(name)
        @class_path = name.include?("/") ? name.split("/") : name.split("::")
        @class_path.map!(&:underscore)
        @file_name = @class_path.pop
      end

      # Add a class collisions name to be checked on class initialization. You
      # can supply a hash with a :prefix or :suffix to be tested.
      #
      # ==== Examples
      #
      #   check_class_collision suffix: "Decorator"
      #
      # If the generator is invoked with class name Admin, it will check for
      # the presence of "AdminDecorator".
      #
      def self.check_class_collision(options = {}) # :doc:
        define_method "check_class_collision_#{options[:suffix]}_#{options[:prefix]}" do
          name = class_name

          class_collisions "#{options[:prefix]}#{name}#{options[:suffix]}"
        end
      end
    end
  end
end
