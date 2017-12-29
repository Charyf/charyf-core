# frozen_string_literal: true

require_relative 'initializable'
require_relative '../support'

module Charyf
  class Extension
    include Initializable

    ABSTRACT = %w(Charyf::Extension Charyf::AppEngine Charyf::Application)

    class << self
      private :new

      def abstract?
        ABSTRACT.include?(name)
      end

      def subclasses
        @subclasses ||= []
      end

      def inherited(base)
        # unless base.abstract?
        subclasses << base
        # end
      end

      def generators(&blk)
        register_block_for(:generators, &blk)
      end

      # Since Charyf::Extension cannot be instantiated, any methods that call
      # +instance+ are intended to be called only on subclasses of a Extension.
      def instance
        @instance ||= new
      end

      def extension_name(name = nil)
        @extension_name = name.to_s if name
        @extension_name ||= generate_extension_name(self.name)
      end

      private

      def generate_extension_name(string)
        string.underscore.tr('/', '_')
      end

      # Allows you to configure the Extension. This is the same method seen in
      # Extension::Configurable, but this module is no longer required for all
      # subclasses of Extension so we provide the class method here.
      def configure(&block)
        instance.configure(&block)
      end

      def config
        instance.config
      end

      def respond_to_missing?(name, _)
        instance.respond_to?(name) || super
      end

      # If the class method does not have a method, then send the method call
      # to the Extension instance.
      def method_missing(name, *args, &block)
        if instance.respond_to?(name)
          instance.public_send(name, *args, &block)
        else
          super
        end
      end

      # receives an instance variable identifier, set the variable value if is
      # blank and append given block to value, which will be used later in
      # `#each_registered_block(type, &block)`
      def register_block_for(type, &blk)
        var_name = "@#{type}"
        blocks = instance_variable_defined?(var_name) ? instance_variable_get(var_name) : instance_variable_set(var_name, [])
        blocks << blk if blk
        blocks
      end
    end # End of self

    def initialize #:nodoc:
      if self.class.abstract?
        raise "#{self.class.name} is abstract, you cannot instantiate it directly."
      end
    end

    def extension_name(name)
      self.class.extension_name(name)
    end

    def configure(&block) #:nodoc:
      instance_eval(&block)
    end

    def extension_namespace #:nodoc:
      @extension_namespace ||= self.class.parents.detect { |n| n.respond_to?(:extension_namespace) }
    end

    # This is used to create the <tt>config</tt> object on Extensions, an instance of
    # Extension::Configuration, that is used by Extensions and Application to store
    # related configuration.
    def config
      @config ||= Charyf::Extension::Configuration.new
    end

    protected

    def run_generators_blocks(app) #:nodoc:
      each_registered_block(:generators) { |block| block.call(app) }
    end

    private

    # run `&block` in every registered block in `#register_block_for`
    def each_registered_block(type, &block)
      klass = self.class
      while klass.respond_to?(type)
        klass.public_send(type).each(&block)
        klass = klass.superclass
      end
    end

  end
end