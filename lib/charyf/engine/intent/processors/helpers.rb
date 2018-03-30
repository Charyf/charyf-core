module Charyf
  module Engine
    class Intent
      module Processor
        module Helpers

          def self.included(base)
            base.extend(ClassMethods)
          end

          module ClassMethods
          end # End of ClassMethods

          def unknown
            Charyf::Engine::Intent.unknown
          end

        end
      end
    end
  end
end