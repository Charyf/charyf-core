module Charyf
  module Controller
    module Actions

      class InvalidDefinitionError < StandardError; end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def before_action(method_name, on_all = nil, only: [], except: [])
          (@_before_actions ||= {})[method_name] = Charyf::Utils.create_action_filters(on_all, only, except)
        end

        def _before_actions(action)
          (@_before_actions || {}).select { |_,v| Charyf::Utils.match_action_filters?(action.to_sym, v) }.keys
        end

      end # End of ClassMethods

      def logger
        Charyf.logger
      end

    end
  end
end
