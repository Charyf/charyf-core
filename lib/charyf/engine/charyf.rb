# Dependency on utils
require 'charyf/utils/all'

require_relative 'dispatcher'

module Charyf

  class << self

    sig [], 'Charyf::Engine::Dispatcher',
    def dispatcher
      Charyf::Engine::Dispatcher.new
    end

  end

end