module Charyf
  module ErrorHandlers

    extend self

    def<<(handler)
      handlers << handler
    end

    def handle_exception(e)
      Charyf.logger.error "#{e.class}: #{e}".red
      Charyf.logger.error "\n\tBacktrace: #{e.backtrace.join("\n\t")}"

      handlers.map { |h| h.handle_exception(e) }

      e
    end

    private

    def handlers
      @handles ||= []
    end

  end
end