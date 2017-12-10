module Charyf
  module Engine
    class Intent
      module Processor
        module Helpers

          def self.included(base)
            base.extend(ClassMethods)
          end

          module ClassMethods

            def scoped_name(skill_name, *args)
              ([skill_name.to_s] + args).join('_')
            end

            def unscope_name(skill_name, name)
              name.start_with?(skill_name.to_s) ? name.sub("#{skill_name.to_s}_", '') : name
            end

          end # End of ClassMethods

          sig [], 'Charyf::Engine::Intent',
          def unknown
            Charyf::Engine::Intent::UNKNOWN
          end

        end
      end
    end
  end
end