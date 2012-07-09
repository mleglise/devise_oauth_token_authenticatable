# Originally based on:
# https://github.com/socialcast/devise_oauth2_providable/blob/master/lib/devise/oauth2_providable/strategies/oauth2_providable_strategy.rb

require 'devise/strategies/base'

# TODO: Specify a failure app that's custom for this strategy.
# If the strategy was valid (because it had an access token in the header or params)
# but it failed, then the responses should be in the 4XX range, not 3XX redirects

module Devise
  module Strategies
    class OauthTokenAuthenticatable < Authenticatable

      def valid?
        @req = Rack::OAuth2::Server::Resource::Bearer::Request.new(env)
        @req.oauth2?
      end

      def authenticate!
        @req.setup!
        resource = mapping.to.find_for_oauth_token_authentication( @req.access_token )
        if validate(resource)
          resource.after_oauth_token_authentication
          success! resource
        elsif !halted?
          fail(:invalid_token)
        end
      end

      # Do not store OauthToken validation in session.
      # This forces the strategy to check the token on every request.
      def store?
        false
      end

    private

      # Do not use remember_me behavior with token.
      def remember_me?
        false
      end

    end # OauthTokenAuthenticatable
  end # Strategies
end # Devise

Warden::Strategies.add(:oauth_token_authenticatable, Devise::Strategies::OauthTokenAuthenticatable)
