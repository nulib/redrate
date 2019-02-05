# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redrate/version'

Gem::Specification.new do |spec|
  spec.name          = 'redrate'
  spec.version       = Redrate::VERSION
  spec.authors       = ['Michael B. Klein']
  spec.email         = ['mbklein@gmail.com']

  spec.summary       = 'An easy, distributed rate limiter using Redis'
  spec.homepage      = 'https://github.com/nulib/redrate.git'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'redis'
  spec.add_dependency 'redlock'
  spec.add_development_dependency 'bixby'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
