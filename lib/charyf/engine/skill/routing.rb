module Charyf
  module Skill
    module Routing

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        sig ['Pathname'], ['Pathname'],
        def routing_source_dir(abs_path = nil)
          if abs_path
            @_routing_source_dir = abs_path
          end

          @_routing_source_dir || skill_root.join('intents')
        end

        def public_routing_for(processor_name)
          _public_routing(processor_name) << Proc.new

          nil
        end

        def private_routing_for(processor_name)
          _private_routing(processor_name) << Proc.new

          nil
        end


        def _public_routing(processor)
          processor = processor.to_sym

          @_public_routing ||= Hash.new

          @_public_routing[processor] ||= []

          @_public_routing[processor]
        end

        def _private_routing(processor)
          processor = processor.to_sym

          @_public_routing ||= Hash.new

          @_public_routing[processor] ||= []

          @_public_routing[processor]
        end

      end # End of ClassMethods

    end
  end
end