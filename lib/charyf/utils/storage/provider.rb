require_relative '../strategy/base_class'
require_relative '../strategy/owner_class'

module Charyf
  module Utils
    module StorageProvider

      extend Charyf::Strategy::OwnerClass

      class Base

        include Charyf::Strategy::BaseClass

        def self.get_for(klass)
          raise Charyf::Utils::NotImplemented.new
        end

        def get(key)
          raise Charyf::Utils::NotImplemented.new
        end

        def store(key, value)
          raise Charyf::Utils::NotImplemented.new
        end

        def remove(key)
          raise Charyf::Utils::NotImplemented.new
        end

      end # End of Base
    end
  end
end