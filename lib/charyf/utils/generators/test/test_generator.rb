# frozen_string_literal: true

require_relative '../app_base'
require_relative '../../../support'

module Charyf
  module Generators
    class TestGenerator < Base # :nodoc:

      def print_debug_message
        puts 'YEAH'
      end

    end
  end
end
