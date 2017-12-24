# frozen_string_literal: true
require_relative '../../support'

module Charyf
  module Command
    module Behavior #:nodoc:

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Remove the color from output.
        def no_color!
          Thor::Base.shell = Thor::Shell::Basic
        end

        private

        # This code is based dir
        # Prints a list of generators.
        def print_list(base, namespaces)
          return if namespaces.nil? ||namespaces.empty?
          puts "#{base.camelize}:"

          namespaces.each do |namespace|
            puts("  #{namespace}")
          end

          puts
        end

      end
    end
  end
end
