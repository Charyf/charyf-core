# frozen_string_literal: true

module Charyf
  module Command
    module EnvironmentArgument #:nodoc:


      def self.included(base)
        base.class_option :environment, aliases: "-e", type: :string,
                     desc: "Specifies the environment to run this console under (test/development/production)."
      end

      private
      def extract_environment_option
        if options[:environment]
          self.options = options.merge(environment: acceptable_environment(options[:environment]))
        else
          self.options = options.merge(environment: Charyf::Command.environment)
        end
      end

      def acceptable_environment(env = nil)
        if available_environments.include? env
          env
        else
          %w( production development test ).detect { |e| e =~ /^#{env}/ } || env
        end
      end

      def available_environments
        if Object.const_defined? 'APP_PATH'
          app_path = File.expand_path("..", APP_PATH)
          return Dir[app_path + "/environments/*.rb"].map { |fname| File.basename(fname, ".*") }
        end

        []
      end
    end
  end
end
