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
    class Context; end
    class Dispatcher; end
    class Intent; end
    class Request; end
    class Response; end
    class Session; end
  end

end

require_relative 'interface/program'
require_relative 'controller/base'

require_relative 'charyf'
require_relative 'commands'
require_relative 'context'
require_relative 'dispatcher'
require_relative 'intent'
require_relative 'request'
require_relative 'response'
require_relative 'session'
