require_relative '../strategy'

module Charyf
  module Utils
    module StorageProvider
      class Base

        include Charyf::Strategy
        def self.base
          Base
        end

        def self.get_for(klass)
          raise Charyf::Utils::NotImplemented.new
        end

        sig [nil], [nil],
        def get(key)
          raise Charyf::Utils::NotImplemented.new
        end

        sig [nil, nil], [nil],
        def store(key, value)
          raise Charyf::Utils::NotImplemented.new
        end

        sig [nil], [nil],
        def remove(key)
          raise Charyf::Utils::NotImplemented.new
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