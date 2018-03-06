# frozen_string_literal: true

module Charyf
  module Command
    module Actions

      # def set_application_directory!
      #   Dir.chdir(File.expand_path("../..", APP_PATH)) unless File.exist?(File.expand_path("config.ru"))
      # end

      def require_application_and_environment!(group = :default)
        if defined?(APP_PATH)
          require APP_PATH
          Charyf.application.initialize!(group)
        end
      end

      def load_generators
        Charyf.application.load_generators
      end

      def start_interfaces!
        Charyf.application.start_interfaces
      end

      def start_pipeline!
        Charyf.application.start_pipeline
      end

    end
  end
end
