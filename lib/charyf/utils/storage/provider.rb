require_relative '../strategy/base_class'
require_relative '../strategy/owner_class'

module Charyf
  module Utils
    module StorageProvider

      extend Charyf::Strategy::OwnerClass

      class Base

        include Charyf::Strategy::BaseClass

        sig_self [['Module', 'String']], ['Charyf::Utils::StorageProvider::Base'],
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
    end
  end
end