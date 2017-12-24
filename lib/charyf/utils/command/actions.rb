# frozen_string_literal: true

module Charyf
  module Command
    module Actions

      # def set_application_directory!
      #   binding.pry
      #   Dir.chdir(File.expand_path("../..", APP_PATH)) unless File.exist?(File.expand_path("config.ru"))
      # end

      def require_application_and_environment!
        if defined?(APP_PATH)
          require APP_PATH
          Charyf.application.initialize!
        end
      end
    end
  end
end
