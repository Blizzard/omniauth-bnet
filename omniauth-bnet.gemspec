# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-bnet/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-bnet"
  spec.version       = OmniAuth::Bnet::VERSION
  spec.authors       = ["Christopher Giroir"]
  spec.email         = ["cgiroir@blizzard.com"]
  spec.summary       = %q{Omniauth Strategy for Battle.net}
  spec.description   = %q{Omniauth Strategy for Battle.net OAuth Login. For more info visit https://dev.battle.net}
  spec.homepage      = "https://github.com/Blizzard/omniauth-bnet"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'omniauth', '~> 1.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.1'

  spec.add_development_dependency "bundler", "~> 2.5"
  spec.add_development_dependency "rake", "~> 0"
end
