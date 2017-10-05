# Module hierarchy
module Charyf
  module Commands
    class Base; end
    class CLI < Base; end
    class Console < Base; end
  end

  module Controller
    class Base; end
  end

  module Interface
    class Base; end
    class Program < Base; end
  end

  module Engine

    class Intent
      class DummyProcessor; end
    end

    class Session
      class DummyProcessor; end
    end

    class Context; end
    class Dispatcher; end
    class Request; end
    class Response; end
  end

end

require_relative 'intent/intent'
require_relative 'intent/processor'
require_relative 'interface/program'
require_relative 'controller/base'
require_relative 'session/session'
require_relative 'session/processor'

require_relative 'charyf'
require_relative 'commands'
require_relative 'context'
require_relative 'dispatcher'
require_relative 'request'
require_relative 'response'
