# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'samwise/version'

Gem::Specification.new do |gem|
  gem.name          = "samwise"
  gem.version       = Samwise::VERSION
  gem.summary       = %q{Ruby access to the SAM.gov API}
  gem.description   = %q{A Ruby library that provides access to the SAM.gov API}
  gem.license       = "Public Domain. See CONTRIBUTING.md."
  gem.authors       = ["Alan deLevie"]
  gem.email         = "alan.delevie@gsa.gov"
  gem.homepage      = "https://rubygems.org/gems/samwise"

  gem.files         = `git ls-files`.split($/)

  `git submodule --quiet foreach --recursive pwd`.split($/).each do |submodule|
    submodule.sub!("#{Dir.pwd}/",'')

    Dir.chdir(submodule) do
      `git ls-files`.split($/).map do |subpath|
        gem.files << File.join(submodule,subpath)
      end
    end
  end
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'codeclimate-test-reporter', '~> 0.1'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rdoc', '~> 4.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'thor'

  gem.add_runtime_dependency 'httpclient'
  gem.add_runtime_dependency 'faraday'
end
