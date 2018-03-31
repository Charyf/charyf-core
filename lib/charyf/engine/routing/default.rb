require_relative 'router'

module Charyf
  module Engine
    module Routing
      class Default < Base

        class InvalidRoute < StandardError; end

        strategy_name :default

        def initialize
          @routes = {
              Charyf::Engine::Intent.unknown.name => unknown
          }
        end

        def draw(&block)
          instance_eval &block
        end

        # Context -> Controller
        def process(context)
          @routes[context.intent.name.downcase] || invalid
        end

        def route(intent, to: nil)
          raise InvalidRoute.new("route '#{intent}' missing to definition") if to.nil?

          @routes[intent.downcase] = parse_target(to)
        end

        private

        def parse_target(to)
          if to.is_a? Hash
            raise InvalidRoute.new("route '#{intent}' incomplete to definition") unless to.keys.map(&:to_sym) & [:skill, :controller, :action] == [:skill, :controller, :action]

            return Result.new(to[:skill], to[:controller], to[:action])
          end

          if to.is_a? String
            path, action = to.split("#")
            path = path.split("/")

            skill = path.delete_at(0)
            controller = path.join("/")

            return Result.new(skill, controller, action)
          end

          raise InvalidRoute.new("Unknown definition  to:#{to}")
        end

      end
    end
  end
end
