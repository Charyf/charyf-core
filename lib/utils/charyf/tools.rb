require 'pathname'

module Charyf
  module Tools

    def self.find_root_with_flag(flag, root_path, default = nil) #:nodoc:
      while root_path && File.directory?(root_path) && !File.exist?("#{root_path}/#{flag}")
        parent = File.dirname(root_path)
        root_path = parent != root_path && parent
      end

      root = File.exist?("#{root_path}/#{flag}") ? root_path : default
      raise "Could not find root path for #{self}" unless root

      Pathname.new File.realpath root
    end

  end
end
