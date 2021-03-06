module Charyf
  module Configuration

    class Generators #:nodoc:
      attr_reader :hidden_namespaces, :installers, :skill_hooks

      def options
        dup = @options.dup
        dup[:charyf] ||= {}
        dup[:installers] = @installers
        dup[:skill_hooks] = @skill_hooks

        dup
      end

      def initialize
        @hidden_namespaces = []
        @installers = []
        @skill_hooks = []
        @options = Hash.new { |h, k| h[k] = {} }
      end

      def hide_namespace(namespace)
        @hidden_namespaces << namespace
      end

      def method_missing(method, *args)
        method = method.to_s.sub(/=$/, "").to_sym

        return @options[method] if args.empty?

        if method == :charyf || args.first.is_a?(Hash)
          namespace, configuration = method, args.shift
        else
          namespace, configuration = args.shift, args.shift
          namespace = namespace.to_sym if namespace.respond_to?(:to_sym)
          @options[:charyf][method] = namespace
        end

        if configuration
          @options[namespace].merge!(configuration)
        end
      end
    end
  end
end