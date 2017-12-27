# frozen_string_literal: true

module Charyf
  class Extension
    module Configurable

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def config
          instance.config
        end

        def inherited(base)
          raise "You cannot inherit from a #{superclass.name} child"
        end

        def instance
          @instance ||= new
        end

        def respond_to?(*args)
          super || instance.respond_to?(*args)
        end

        def configure(&block)
          class_eval(&block)
        end

        private

        def method_missing(*args, &block)
          instance.send(*args, &block)
        end
      end

    end
  end
end
