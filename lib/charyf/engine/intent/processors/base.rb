require 'charyf/utils'
require_relative '../intent'

module Charyf
  module Engine
    class Intent
      module Processors
        class Base


          sig ['Charyf::Engine::Request', ['String', 'Symbol', 'NilClass']], 'Charyf::Engine::Intent',
              def determine(request, skill = nil)
                raise Charyf::Tools::NotImplemented.new
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

            def inherited(subclass)
              Base._subclasses << subclass
            end

            def processor_name(name = nil)
              if name
                @_processor_name = name
                Base._aliases[name] = self
              end

              @_processor_name
            end

            def definition_extension(file_extension = nil)
              if name
                @_definition_extension = file_extension
              end

              @_definition_extension || self.name.demodulize.underscore
            end

            def _subclasses
              @_subclasses ||= []
            end

            def _aliases
              @_aliases ||= Hash.new
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
          Base._subclasses
        end

        def self.list
          Base._aliases
        end

      end
    end
  end
end
