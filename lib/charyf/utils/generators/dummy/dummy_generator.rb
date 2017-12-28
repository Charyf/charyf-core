# frozen_string_literal: true

require_relative '../app_base'

require_relative '../../generators'

require_relative '../../../support'

module Dummy
  module Generators
    class IntentGenerator < Charyf::Generators::Base # :nodoc:

      argument :skill_name, type: :string

      def a
        empty_directory 'dummy'
      end

    end
  end
end
