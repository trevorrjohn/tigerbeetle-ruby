require_relative './lib/tigerbeetle/version'

Gem::Specification.new do |spec|
  spec.name          = 'tigerbeetle'
  spec.version       = TigerBeetle::VERSION
  spec.authors       = ['Anthony D']
  spec.email         = ['anthony.dmitriyev@gmail.com']

  spec.summary       = 'TigerBeetle Ruby client'
  spec.description   = 'A Ruby client for interacting with the TigerBeetle ledger'
  spec.homepage      = 'https://github.com/antstorm/tigerbeetle-ruby'
  spec.license       = 'Apache-2.0'

  spec.require_paths = ['lib']
  spec.files         = Dir["{lib}/**/*.*"] + %w(tigerbeetle.gemspec Gemfile LICENSE README.md)

  spec.add_dependency 'ffi'

  spec.add_development_dependency 'rake'
end
