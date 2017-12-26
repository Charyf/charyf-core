require_relative '../../../utils'

require_relative 'helpers'
require_relative '../intent'

module Charyf
  module Engine
    class Intent
      module Processor
        class Base

          include Charyf::Strategy
          include Charyf::Engine::Intent::Processor::Helpers

          def self.base
            Base
          end

          sig ['Charyf::Engine::Request'], 'Charyf::Engine::Intent',
          def determine(request)
            raise Charyf::Utils::NotImplemented.new
          end

          #
          # Load single block of intent definitions
          #
          sig_self ['Symbol', 'Proc'], nil,
          def load(skill_name, block)
            raise Charyf::Utils::NotImplemented.new
          end

          sig_self [], [nil],
          def self.setup
            # Override to run your setup
          end

          sig_self ['Symbol'], 'Charyf::Engine::Intent::Processor::Base',
          def self.get_for(skill = nil)
            raise Charyf::Utils::NotImplemented.new
          end

          sig_self [], 'Charyf::Engine::Intent::Processor::Base',
          def self.get_global
            get_for(nil)
          end

        end


        def self.known
          Base.known
        end

        def self.list
          Base.list
        end

      end
    end
  end
end
