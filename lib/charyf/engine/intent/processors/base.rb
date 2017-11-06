require 'charyf/utils'
require_relative '../intent'

module Charyf
  module Engine
    class Intent
      module Processors
        class Base

          class << self

            def inherited(subclass)
              Base._subclasses[subclass.name.demodulize.underscore] = subclass
            end

            def _subclasses
              @_subclasses ||= Hash.new
            end

            def scoped_name(skill, *args)
              ([skill.to_s] + args).join('_')
            end

            def unscope_name(skill, name)
              name.start_with?(skill.to_s) ? name.sub("#{skill.to_s}_", '') : name
            end

          end

          sig ['Charyf::Engine::Request', ['String', 'Symbol', 'NilClass']], 'Charyf::Engine::Intent',
          def determine(request, skill = nil)
            raise Charyf::Tools::NotImplemented.new
          end

          sig [], 'Charyf::Engine::Intent',
          def unknown
            Charyf::Engine::Intent::UNKNOWN
          end

        end

        def self.list
          Base._subclasses
        end

      end
    end
  end
end
