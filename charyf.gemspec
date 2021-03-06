
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'charyf/version'

Gem::Specification.new do |spec|
  spec.name          = 'charyf'
  spec.version       = Charyf::VERSION::STRING
  spec.authors       = ['Richard Ludvigh']
  spec.email         = ['richard.ludvigh@gmail.com']

  spec.summary       = 'Your favorite modular chatbot ruby framework'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/Charyf/charyf-core'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.1'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  # end

  spec.files         = Dir['**/*'].reject do |f|
    f.match(%r{^(test|spec|features|pkg)/})
  end
  spec.require_paths = ['lib']

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  # Internal dependencies

  # External dependencies
  spec.add_runtime_dependency 'i18n', '~> 0.9'
  spec.add_runtime_dependency 'colorize', '~> 0.8'
  spec.add_runtime_dependency 'thor', '>= 0.18.1', '< 2.0'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 1.15.4'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10'
end
