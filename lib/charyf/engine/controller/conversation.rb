module Charyf
  module Controller
    module Conversation

      class InvalidDefinitionError < StandardError; end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        # def auto_keep_conversation(only: [], except: [])
        #   if only && !only.empty? && except && !except.empty?
        #     raise InvalidDefinitionError.new("Define only or except, don't define both");
        #   end
        #
        #   @_converse_on = (except && !except.empty?) ? :all : only.map(&:to_sym)
        #   @_dont_converse_on = except.map(&:to_sym)
        # end
        #
        # def _converse_on?(action)
        #   (@_converse_on == :all && !@_dont_converse_on.include?(action.to_sym)) ||
        #       ((@_converse_on != :all) && (@_converse_on || []).include?(action.to_sym))
        # end

      end # End of ClassMethods

      # def init_machine(machine)
      #
      # end

      # def keep_conversation(controller: nil, action: nil, store: Hash.new)
      #   session = @context.session || Charyf::Engine::Session.init(request.id, intent.skill)
      #
      #   if action
      #     controller ||= controller_name
      #     session.route_to(controller, action)
      #   end
      #
      #   unless store.empty?
      #     store.each do |k,v|
      #       session.storage.store(k, v)
      #     end
      #   end
      #
      #   session.keep!
      # end
      #
      # def end_conversation
      #   session.invalidate! if session
      #
      #   nil
      # end

    end
  end
end
