require 'fileutils'

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
      @_env ||= Charyf::StringInquirer.new(ENV["CHARYF_ENV"] || "development")
    end

    def env=(environment)
      @_env = Charyf::StringInquirer.new(environment)
    end

    def logger
      return @logger if @logger

      FileUtils.mkdir_p root.join('log')
      @logger = Charyf::Logger.new(Charyf.root.join('log', "#{env}.log"))
    end

    def groups(*groups)
      # TODO
      [:default, env]
    end

  end

end