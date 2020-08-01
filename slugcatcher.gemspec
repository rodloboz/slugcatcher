
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "slugcatcher/version"

Gem::Specification.new do |spec|
  spec.name          = "slugcatcher"
  spec.version       = Slugcatcher::VERSION
  spec.authors       = ["Rui Freitas"]
  spec.email         = ["dinnerpartysaboteur@gmail.com"]

  spec.summary       = %q{Dynamic slugs lookup for Rails.}
  spec.description   = %q{With Slugcatcher, you can mark your models for dynamic url slug matching and lookup.}
  spec.homepage      = "https://github.com/rodloboz/slugcatcher"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'railties', '>= 4.0'
  spec.add_dependency 'activerecord', '>= 4.0'
  spec.add_dependency 'activesupport', '>= 4.0'

  spec.add_development_dependency 'rails', '~> 4.0'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.7.0"
  spec.add_development_dependency 'rspec-rails', '~> 3.7.2'
  spec.add_development_dependency 'sqlite3', '~> 1.3.13'
  spec.add_development_dependency 'database_cleaner', '~> 1.7.0'
  spec.add_development_dependency 'appraisal', '~> 2.2.0'
end
