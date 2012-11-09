$:.push File.expand_path('../lib', __FILE__)
require 'drink-socially/version'

Gem::Specification.new do |s|
  s.name          = 'drink-socially'
  s.summary       = 'A gem for interfacing with the Untappd API'
  s.description   = 'See summary'

  s.homepage          = 'https://github.com/NewRepublicBrewing/drink-socially'
  s.rubyforge_project = 'drink-socially'

  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware-parse_oj'

  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rb-inotify'

  s.authors       = ['Dean Brundage']
  s.email         = ['dean@newrepublicbrewing.com']

  s.files         = [ 'README.md', 'lib/drink-socially.rb' ]
  s.test_files    = [ 'spec/drink-socially_spec.rb' ]
  s.require_paths = ['lib']

  s.platform      = Gem::Platform::RUBY
  s.version       = NRB::Untappd.version
end
