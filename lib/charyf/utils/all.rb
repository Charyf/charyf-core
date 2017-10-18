# Module hierarchy
module Charyf
  class Application
    module Bootstrap; end
    class Configuration; end
  end

  module Generators
    class Base; end
    class Install < Base; end
  end

  module ErrorHandlers; end

  module Initializable; end

  require 'logger'
  class Logger < ::Logger; end


  class StringInquirer < String; end

  module Tools
    class NotImplemented < StandardError; end
    class InvalidPath < StandardError; end
  end
end

require_relative 'generators/base'
require_relative 'generators/install'

require_relative 'application'
require_relative 'charyf'
require_relative 'error_handler'
require_relative 'initializable'
require_relative 'logger'
require_relative 'string'
require_relative 'string_inquirer'
require_relative 'tools'
