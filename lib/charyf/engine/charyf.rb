# Dependency on utils
require 'charyf/utils/all'

module Charyf

  class << self

    sig [], Charyf::Engine::Dispatcher,
    def dispatcher
      Charyf::Engine::Dispatcher.new
    end

  end

end