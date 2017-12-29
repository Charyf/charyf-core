module Charyf
  module Skill
    module Info

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        sig ['String', 'Symbol', 'NilClass'], ['Symbol'],
        def skill_name(name = nil)
          if name
            @_name = name.to_sym
          end

          @_name || self.name.gsub('::', ' ')
        end

      end

    end
  end
end