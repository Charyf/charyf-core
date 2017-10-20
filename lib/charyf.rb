require 'charyf/version'

# Require dependencies on other gems
require 'charyf/deps'

# Require utils
require 'charyf/utils'

# Require charyf engine core
require 'charyf/engine'

module Charyf

  def self._gem_source
    Pathname.new(__FILE__).dirname
  end
  # Your code goes here...
end
