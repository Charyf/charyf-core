# Dependency on utils
require 'utils/charyf'
# Dependency on API
require 'api/charyf'

# Require Engine files
require_relative 'charyf/all'

module Charyf

  class << self

    def dispatcher
      Charyf::Engine::Dispatcher.new
    end

  end

end