# -*- encoding: utf-8 -*-
require File.expand_path('../lib/devise/oauth_token_authenticatable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "devise_oauth_token_authenticatable"
  gem.version       = Devise::OauthTokenAuthenticatable::VERSION
  gem.authors       = ["Marc Leglise"]
  gem.email         = ["mleglise@gmail.com"]
  gem.summary       = %q{Allows Rails 3 + Devise to authenticate users via an OAuth Access Token from a 3rd party provider.}
  gem.description   = %q{
There are plenty of gems out there that deal with being an OAuth2 "consumer",
where you redirect users to an OAuth2 "provider", allowing you to hand off
authentication to a separate service. There are also plenty of gems that set
you up as your own OAuth2 provider. ***BUT***, what happens when you want to
separate your "authentication" server from your "resource" server?

This gem is meant to be used on an API "resource" server, where you want to
accept OAuth Access Tokens from a client, and validate them against a separate
"authentication" server. This communication is outside the scope of the
official OAuth 2 spec, but there is a need for it anyway.
  }
  gem.homepage      = "https://github.com/mleglise/devise_oauth_token_authenticatable"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency("rails", [">= 3.1.0"])
  gem.add_runtime_dependency("devise", [">= 2.1.0"])
  gem.add_runtime_dependency("oauth2", ["~> 0.6.1"])
  gem.add_runtime_dependency("rack-oauth2", [">= 0.14.0"])
  gem.add_development_dependency('rspec-rails', ['>= 2.6.1'])
  gem.add_development_dependency('sqlite3', ['>= 1.3.5'])
  gem.add_development_dependency('shoulda-matchers', ['>= 1.0.0.beta3'])
  gem.add_development_dependency('factory_girl', ['>= 2.2.0'])
  gem.add_development_dependency('factory_girl_rspec', ['>= 0.0.1'])
  gem.add_development_dependency('rake', ['>= 0.9.2.2'])
  gem.add_development_dependency('webmock', ['>= 1.8.8'])
end
