module Charyf
  module Strategy
    module BaseClass

      class << self
        def included(base)
          base.extend(ClassMethods)
          base.instance_variable_set('@_base_class', base)
        end
      end

      module ClassMethods
        def inherited(subclass)
          base._subclasses << subclass
          subclass.instance_variable_set('@_base_class', base)
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
          @_base_class
        end
      end

    end
  end
end