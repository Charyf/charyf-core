module Charyf
  module Strategy

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def inherited(subclass)
        base._subclasses << subclass
      end

      def strategy_name(name = nil)
        if name
          @_strategy_name = name
          base._aliases[name] = self
        end

        @_strategy_name
      end

      def _subclasses
        @_subclasses ||= []
      end

      def _aliases
        @_aliases ||= Hash.new
      end

      def known
        base._subclasses
      end

      def list
        base._aliases
      end

      def base
        raise Charyf::Utils::NotImplemented.new("No base class found for #{self}")
      end
    end

  end
end