module Charyf
  module Strategy
    module OwnerClass

      def known
        base_class.known
      end

      def list
        base_class.list
      end

      def base_class(name = nil)
        if name
          @_base_class = name
        end

        self.const_get(@_base_class || :Base)
      end

    end
  end
end