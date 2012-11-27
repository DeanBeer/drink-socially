$:.push File.expand_path('../lib', __FILE__)
require 'drink-socially/version'

Gem::Specification.new do |s|
  s.name          = 'drink-socially'
  s.summary       = 'An interface for the Untappd API'
  s.description   = 'Untappd is a way to socially share and explore beer with your friends and the world.  This gem interfaces with version 4 of the Untappd API'

  s.homepage          = 'https://github.com/NewRepublicBrewing/drink-socially'
  s.rubyforge_project = 'drink-socially'

  s.add_dependency 'faraday', '~> 0.0'
  s.add_dependency 'faraday_middleware-parse_oj', '~> 0.0'
  s.add_dependency 'hashie', '~> 1.0'

  s.add_development_dependency 'guard-rspec', '~> 2.0'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 2.0'
  s.add_development_dependency 'rb-inotify', '~> 0.0' # Filesystem watcher for Guard on Linux

  s.authors       = ['Dean Brundage']
  s.email         = ['dean@newrepublicbrewing.com']

  s.files         = [
                      'LICENSE',
                      'README.md',
                      'config/endpoints.yml',
                      'lib/drink-socially.rb',
                      'lib/drink-socially/api.rb',
                      'lib/drink-socially/api/credential.rb',
                      'lib/drink-socially/api/notification.rb',
                      'lib/drink-socially/api/object.rb',
                      'lib/drink-socially/api/pagination.rb',
                      'lib/drink-socially/api/rate_limit.rb',
                      'lib/drink-socially/api/url_tokenizer.rb',
                      'lib/drink-socially/config.rb',
                      'lib/drink-socially/extensions/hash.rb',
                      'lib/drink-socially/http_service.rb',
                      'lib/drink-socially/http_service/response.rb',
                      'lib/drink-socially/version.rb'
                    ]
  s.test_files    = [ 
                      'spec/cases/drink-socially/api/credential_spec.rb',
                      'spec/cases/drink-socially/api/object_spec.rb',
                      'spec/cases/drink-socially/api/pagination_spec.rb',
                      'spec/cases/drink-socially/api/rate_limit_spec.rb',
                      'spec/cases/drink-socially/api/url_tokenizer_spec.rb',
                      'spec/cases/drink-socially/api_spec.rb',
                      'spec/cases/drink-socially/config_spec.rb',
                      'spec/cases/drink-socially/extensions/hash_spec.rb',
                      'spec/cases/drink-socially/http_service/response_spec.rb',
                      'spec/cases/drink-socially/http_service_spec.rb',
                      'spec/cases/drink-socially/version_spec.rb',
                      'spec/cases/drink-socially_spec.rb',
                      'spec/spec_helper.rb',
                      'spec/support/config.yml'
                    ]
  s.require_paths = ['lib']

  s.platform      = Gem::Platform::RUBY
  s.version       = NRB::Untappd.version
end
