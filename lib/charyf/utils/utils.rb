require 'pathname'

module Charyf
  module Utils

    class NotImplemented < StandardError; end
    class InvalidPath < StandardError; end
    class InvalidConfiguration < StandardError; end
    class InvalidDefinitionError < StandardError; end

    def self.find_root_with_flag(flag, root_path, default: nil, namespace: 'charyf') #:nodoc:
      root_path = Pathname.new(root_path)

      root_path = root_path.join(namespace) if namespace && File.directory?(root_path.join(namespace))

      while root_path && File.directory?(root_path) && !File.exist?(root_path.join(flag))
        parent = root_path.dirname
        root_path = parent != root_path && parent
      end

      root = File.exist?("#{root_path}/#{flag}") ? root_path : default
      raise InvalidPath.new("Could not find root path for #{self}") unless root

      Pathname.new File.realpath root
    end

    # Requires files before recursion into directory
    def self.require_recursive(path, condition: nil)
      unless File.directory? path
        require path if !condition || condition.call(path)
      end

      files = Dir[path.join('**')].select { |p| !File.directory?(p) }
      dirs = Dir[path.join('**')].select { |p| File.directory?(p) }

      (files + dirs).each do |item|
        require_recursive Pathname.new(item), condition: condition
      end
    end

    sig_self [['Symbol', 'Array'], 'Array'], 'Hash',
    def self.create_action_filters(only = [], except = [])
      if only && only != :all && !only.empty? && except && !except.empty?
        raise InvalidDefinitionError.new("Define only or except, don't define both");
      end

      _only = except && except.empty? ? only.map(&:to_sym) : :all
      _except = except.map(&:to_sym)

      {
          only: _only,
          except: _except
      }
    end

    sig_self ['Symbol', 'Hash'], ['TrueClass', 'FalseClass'],
    def self.match_action_filters?(name, filters = {only: [], except: []} )
      (filters[:only] == :all && !filters[:except].include?(name)) ||
          ((filters[:only] != :all) && (filters[:only] || []).include?(name))

    end

  end
end
