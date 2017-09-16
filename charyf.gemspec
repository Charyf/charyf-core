
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "utils/version"

Gem::Specification.new do |spec|
  spec.name          = "charyf"
  spec.version       = Charyf::VERSION
  spec.authors       = ["Richard Ludvigh"]
  spec.email         = ["richard.ludvigh@gmail.com"]

  spec.summary       = %q{Summary is here}
  spec.description   = %q{Desc is here}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir['**/*'].reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib", "templates"]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  # Internal dependencies

  # External dependencies
  spec.add_dependency "activerecord", "5.1.4"

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 1.16.a"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10"
end
