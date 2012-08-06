# Devise OauthTokenAuthenticatable

Ruby gem that allows Rails 3 + Devise to authenticate users via an OAuth Access
Token from a 3rd party provider.

There are plenty of gems out there that deal with being an OAuth2 "consumer",
where you redirect users to an OAuth2 "provider", allowing you to hand off
authentication to a separate service. There are also plenty of gems that set
you up as your own OAuth2 provider. ***BUT***, what happens when you want to
separate your "authentication" server from your "resource" server?

This gem is meant to be used on an API "resource" server, where you want to
accept OAuth Access Tokens from a client, and validate them against a separate
"authentication" server. This communication is outside the scope of the
official [OAuth 2 spec](http://tools.ietf.org/html/draft-ietf-oauth-v2-27), but
there is a need for it anyway.

Comments and suggestions are welcome.

## Requirements

* Devise authentication library
* Rails 3.1 or higher

## Installation

### Add this line to your application's Gemfile:

    gem 'devise_oauth_token_authenticatable'

And then execute:

    $ bundle

### Configure Devise to point to your OAuth authorization server

```ruby
# config/initializers/devise.rb
Devise.setup do |config|
  # ==> Configuration for :oauth_token_authenticatable
  config.oauth_client_id             = "app-id-goes-here"
  config.oauth_client_secret         = "secret-key-goes-here"
  config.oauth_token_validation_url  = "/oauth/verify_credentials"
  config.oauth_client_options        = {
    site: "https://your.oauth.host.com",
    token_method: :get
  }
end
```

### Configure User to support Access Token authentication

You must define the class method `find_for_oauth_token_authentication`, which
will be called by Devise when trying to lookup the user record. It will receive
one string parameter, the Access Token string, as provided by the client.

Your method can then call `validate_oauth_token`, which will do the heavy
lifting of contacting your OAuth Authentication Server at the
token_validation_url and returning an
[OAuth2::AccessToken](https://github.com/intridea/oauth2) object. Your method
can then act as appropriate with the returned data, including using the object
to make additional calls to the Authentication Server.

Your method should return `nil` if the user cannot be authenticated, or an
initialized (and persisted) User object if successful.

NOTE: The docs all refer to the `User` model, but it can be whatever model you
use with Devise.

```ruby
class User
  devise :oauth_token_authenticatable
  
  def self.find_for_oauth_token_authentication(token_str)
    access_token = validate_oauth_token(token_str)
    return nil unless access_token
    User.find_or_create_by_email( access_token.params['email'] )
  end
end
```

## Practical Application

So what does this give you?

A client application can now make calls to your app, providing an access token
in either of two ways.

### Option 1: Query string param

    http://your.app.com/api/cool_stuff?access_token=1234abc

### Option 2: Header param

    GET /api/cool_stuff HTTP/1.1
    Authorization: Bearer 1234abc
    Host: your.app.com

Then, anywhere you would normally call `current_user` with Devise, it will be
automatically interpreted and turned into a real user object. But it's not
based on the session or cookie, it's based on the Access Token!

## To Do

* Add more tests!
* Better error handling

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

This gem was developed by Marc Leglise.
It borrows heavily from [devise\_oauth2\_providable](https://github.com/socialcast/devise_oauth2_providable)
