module Charyf
  # Returns the version of the currently loaded Charyf as a <tt>Gem::Version</tt>
  def self.gem_version
    Gem::Version.new Charyf::VERSION::STRING
  end

  def self.version
    Charyf::VERSION::STRING
  end

  module VERSION
    MAJOR = 0
    MINOR = 2
    TINY  = 7
    PRE   = nil

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")
  end
end
