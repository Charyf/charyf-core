module Charyf
  module Utils
    module StorageProvider
      class Base

        include Charyf::Strategy
        def self.base
          Base
        end

        def self.get_for(klass)

        end

        def get(key)

        end

        def store(key, value)

        end

      end # End of Base

      def self.known
        Base.known
      end

      def self.list
        Base.list
      end
    end
  end
end