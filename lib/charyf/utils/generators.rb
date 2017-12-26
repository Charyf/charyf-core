# frozen_string_literal: true

require 'thor/group'

require_relative 'command/behavior'

module Charyf
  module Generators
    include Charyf::Command::Behavior

    class << self

      # Returns an array of generator namespaces that are hidden.
      # Generator namespaces may be hidden for a variety of reasons.
      def hidden_namespaces
        @hidden_namespaces ||= []
      end


      def hide_namespaces(*namespaces)
        hidden_namespaces.concat(namespaces)
      end

    end # End of self

  end
end
