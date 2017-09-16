require_relative 'charyf/all'

module Charyf

  class << self
    @application = @app_class = nil

    attr_accessor :app_class

    def application
      @application ||= (@app_class.instance if app_class)
    end

    def configuration
      application.config
    end

    def root
      application && application.config.root
    end

    def env
      @_env ||= ENV["CHARYF_ENV"] || "development"
    end

    def env=(environment)
      @_env = environment
    end

    def groups(*groups)

    end

  end

end