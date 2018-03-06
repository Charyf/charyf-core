# frozen_string_literal: true
require_relative '../../command/base'
require_relative '../../command/environment_argument'

module Charyf

  module Command

    class ServerCommand < Base # :nodoc:

      include EnvironmentArgument

      hide_command!

      def perform
        extract_environment_option

        # CHARYF_ENV needs to be set before application is required.
        ENV["CHARYF_ENV"] = options[:environment]

        require_application_and_environment!

        start_interfaces!
        start_pipeline!

      end

    end
  end
end