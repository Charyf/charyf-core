require 'charyf/utils'
require_relative '../intent'

module Charyf
  module Engine
    class Intent
      module Processor
        class Base

          include Charyf::Strategy
          def self.base
            Base
          end


          sig ['Charyf::Engine::Request', ['String', 'Symbol', 'NilClass']], 'Charyf::Engine::Intent',
              def determine(request, skill = nil)
                raise Charyf::Utils::NotImplemented.new
              end

          sig [], 'Charyf::Engine::Intent',
              def unknown
                Charyf::Engine::Intent::UNKNOWN
              end

          def self.setup
              # Override to run your setup
              require_definitions
          end

          class << self

            def definition_extension(file_extension = nil)
              if name
                @_definition_extension = file_extension
              end

              @_definition_extension || strategy_name
            end

            def scoped_name(skill, *args)
              ([skill.to_s] + args).join('_')
            end

            def unscope_name(skill, name)
              name.start_with?(skill.to_s) ? name.sub("#{skill.to_s}_", '') : name
            end

            def require_definitions
              file_pattern = "*.#{self.definition_extension}.rb"

              Charyf::Skill.list.each do |skill_klass|

                # Load routing
                root = skill_klass.skill_root

                Dir[root.join('intents', '**', file_pattern)].each do |definition|
                  require definition
                end

              end
            end

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
