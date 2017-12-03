module Charyf
  module Skill
    module Info

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        sig ['String', 'Symbol'], ['Symbol'],
        def skill_name(name = nil)
          if name
            @_name = name.to_sym
          end

          @_name || self.name.demodulize.to_sym
        end

      end

    end
  end
end