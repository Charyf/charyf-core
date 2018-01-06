# frozen_string_literal: true
require_relative '../configuration'


module Charyf
  class Extension
    class Configuration

      def initialize
        @@options ||= {}
      end

      # Holds generators configuration:
      def generators
        @@generators ||= Charyf::Configuration::Generators.new
        yield(@generators) if block_given?
        @@generators
      end
      #
      # # First configurable block to run. Called before any initializers are run.
      # def before_configuration(&block)
      #   ActiveSupport.on_load(:before_configuration, yield: true, &block)
      # end
      #
      # # Second configurable block to run. Called before frameworks initialize.
      # def before_initialize(&block)
      #   ActiveSupport.on_load(:before_initialize, yield: true, &block)
      # end
      #
      # # Last configurable block to run. Called after frameworks initialize.
      # def after_initialize(&block)
      #   ActiveSupport.on_load(:after_initialize, yield: true, &block)
      # end
      #
      # # Array of callbacks defined by #to_prepare.
      # def to_prepare_blocks
      #   @@to_prepare_blocks ||= []
      # end
      #
      # # Defines generic callbacks to run before #after_initialize. Useful for
      # # Charyf::Extension subclasses.
      # def to_prepare(&blk)
      #   to_prepare_blocks << blk if blk
      # end
      #
      # def respond_to?(name, include_private = false)
      #   super || @@options.key?(name.to_sym)
      # end
      #
      private

      def method_missing(name, *args, &blk)
        if name.to_s =~ /=$/
          @@options[$`.to_sym] = args.first
        elsif @@options.key?(name)
          @@options[name]
        else
          super
        end
      end
    end
  end
end
