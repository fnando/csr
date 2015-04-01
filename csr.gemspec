require './lib/csr/version'

Gem::Specification.new do |spec|
  spec.name          = 'csr'
  spec.version       = CSR::VERSION
  spec.authors       = ['Nando Vieira']
  spec.email         = ['fnando.vieira@gmail.com']
  spec.summary       = 'Generate CSR (Certificate Signing Request) using Ruby and OpenSSL'
  spec.description   = spec.summary
  spec.homepage      = 'http://rubygems.org/gems/csr'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.1.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-rg'
  spec.add_development_dependency 'pry-meta'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
