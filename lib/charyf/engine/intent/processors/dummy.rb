require 'charyf/utils'
require_relative '../intent'

module Charyf
  module Engine
    class Intent
      module Processors
        class Dummy < Base

        def process(request, skill = nil)

            #TODO remove
            if request.text =~ /foo/
              return Charyf::Engine::Intent.new(:Example, :foo_bar, :foo, 100)
            end
            if request.text =~ /bar/
              return Charyf::Engine::Intent.new(:Example, :foo_bar, :bar, 100)
            end
            # TODO TILL HERE


            Charyf::Engine::Intent::UNKNOWN
          end

        end
      end
    end
  end
end