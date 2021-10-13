require_relative 'lib/simple_representer/version'

Gem::Specification.new do |s|
  s.name = 'simple_representer'
  s.version = SimpleRepresenter::VERSION
  s.summary = 'Simple solution to represent your objects as hash or json.'
  s.authors = ['Karol Bąk']
  s.license = 'MIT'
  s.homepage = 'https://github.com/paladinsoftware/simple_representer'

  s.files = `git ls-files`.split($/)
  s.test_files = gem.files.grep(%r{^(test|spec|features)/})
  s.require_paths = %w(lib)

  s.add_runtime_dependency 'oj', '~> 3.10.16'

  s.add_development_dependency 'rspec', '~> 3.10.0'
end
