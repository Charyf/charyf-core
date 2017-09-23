module Charyf
  module ErrorHandlers

    extend self

    def<<(handler)
      handlers << handler
    end

    def handle_exception(e)
      logger.error ' - - - '
      logger.error "#{e.class}: #{e}"
      logger.error "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      logger.error ' - - - '

      handlers.map { |h| h.handle_exception(e) }

      e
    end

    private

    def logger
      @logger ||= Charyf::Logger.new(Charyf.root.join('log', 'error.log'))
    end

    def handlers
      @handles ||= []
    end

  end
end