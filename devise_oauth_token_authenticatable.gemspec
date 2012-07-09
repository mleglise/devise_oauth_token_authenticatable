# -*- encoding: utf-8 -*-
require File.expand_path('../lib/devise/oauth_token_authenticatable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "devise_oauth_token_authenticatable"
  gem.version       = Devise::OauthTokenAuthenticatable::VERSION
  gem.authors       = ["Marc Leglise"]
  gem.email         = ["mleglise@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/mleglise/devise_oauth_token_authenticatable"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency("rails", [">= 3.1.0"])
  gem.add_runtime_dependency("devise", [">= 2.1.0"])
  gem.add_runtime_dependency("oauth2", ["~> 0.6.1"])
  gem.add_runtime_dependency("rack-oauth2", [">= 0.14.0"])
end
