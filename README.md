# Devise OauthTokenAuthenticatable

Ruby gem that allows Rails 3 + Devise to authenticate users via an OAuth Access
Token from a 3rd party provider.

HERE BE DRAGONS! This gem is an extraction from another project, and I'm
ashamed to say does not have any test coverage yet. If you have any suggestions
for how to properly test a Devise module like this, please drop me a line.

## Requirements

* Devise authentication library
* Rails 3.1 or higher

## Installation

### Add this line to your application's Gemfile:

    gem 'devise_oauth_token_authenticatable'

And then execute:

    $ bundle

### Configure Devise to point to your OAuth authorization server.

```ruby
# config/initializers/devise.rb
require 'devise_oauth_token_authenticatable'
Devise.setup do |config|
  # ==> Configuration for :oauth_token_authenticatable
  config.oauth_client_id             = "app-id-goes-here"
  config.oauth_client_secret         = "secret-key-goes-here"
  config.oauth_token_validation_url  = "/oauth/verify\_credentials"
  config.oauth_client_options        = {
    site: "https://your.oauth.host.com",
    token_method: :get
  }
end
```

### Configure User to support Access Token authentication

```ruby
class User
  devise :oauth_token_authenticatable
  
  def self.find_for_oauth_token_authentication(conditions)
    access_token = validate_oauth_token(conditions)
    return nil unless access_token
    User.find_or_create_by_email( access_token.params['email'] )
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

This gem was developed by Marc Leglise.
It borrows heavily from [devise\_oauth2\_providable](https://github.com/socialcast/devise_oauth2_providable)
