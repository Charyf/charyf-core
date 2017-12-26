require_relative 'charyf/version'

# Require dependencies on other gems
require_relative 'charyf/deps'

# Require utils
require_relative 'charyf/utils'

# Require charyf engine core
require_relative 'charyf/engine'

module Charyf

  def self._gem_source
    Pathname.new(__FILE__).dirname
  end

end
