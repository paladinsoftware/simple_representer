require_relative 'lib/simple_representer/version'

Gem::Specification.new do |s|
  s.name = 'simple_representer'
  s.version = SimpleRepresenter::VERSION
  s.summary = 'Simple solution to represent your objects as hash or json.'
  s.authors = ['Karol Bąk']
  s.license = 'MIT'
  s.homepage = 'https://github.com/paladinsoftware/simple_representer'

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  s.require_paths = ['lib']

  s.add_runtime_dependency 'oj', '>= 3.10.16'

  s.add_development_dependency 'rspec', '~> 3.10.0'
end
