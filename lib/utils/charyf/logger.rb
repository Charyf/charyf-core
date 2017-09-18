require 'logger'

module Charyf
  class Logger < ::Logger

    def initialize(logdev, shift_age = 0, shift_size = 1048576)
      super

      self.datetime_format = '%Y-%m-%d %H:%M:%S'

      self.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime} [#{severity}]: #{msg}\n"
      end
    end

  end
end