# Originally based on:
# https://github.com/socialcast/devise_oauth2_providable/blob/master/lib/devise/oauth2_providable/strategies/oauth2_providable_strategy.rb

require 'devise/strategies/base'

# TODO: Specify a failure app that's custom for this strategy.
# If the strategy was valid (because it had an access token in the header or params)
# but it failed, then the responses should be in the 4XX range, not 3XX redirects

module Devise
  module Strategies
    class OauthTokenAuthenticatable < Authenticatable

      # Return true or false, indicating if this strategy is applicable
      def valid?
        @token = setup!
        @token.present?
      end

      def authenticate!
        resource = mapping.to.find_for_oauth_token_authentication( @token )
        if validate(resource)
          resource.after_oauth_token_authentication
          success! resource
        elsif !halted?
          fail(:invalid_token)
        end
      rescue ::OAuth2::Error
        oauth_error! :invalid_token, 'invalid access token'
      end

      # This method copied in from 'devise_oauth2_providable'
      # lib/devise/oauth2_providable/strategies/oauth2_grant_type_strategy.rb
      # return custom error response in accordance with the oauth spec
      # see http://tools.ietf.org/html/draft-ietf-oauth-v2-16#section-4.3
      def oauth_error!(error_code = :invalid_request, description = nil)
        body = {:error => error_code}
        body[:error_description] = description if description
        custom! [401, {'Content-Type' => 'application/json'}, [body.to_json]]
        throw :warden
      end

      # Do not store OauthToken validation in session.
      # This forces the strategy to check the token on every request.
      def store?
        false
      end

    private

      def setup!
        tokens = [access_token_in_header, access_token_in_payload].compact
        return case Array(tokens).size
        when 0
          nil
        when 1
          tokens.first
        else
          invalid_request!('Both Authorization header and payload includes access token.')
        end
      end

      def access_token_in_header
        @auth_header = Rack::Auth::AbstractRequest.new(env)
        if @auth_header.provided? && @auth_header.scheme == :bearer
          @auth_header.params
        else
          nil
        end
      end

      def access_token_in_payload
        params['access_token']
      end

      # Do not use remember_me behavior with token.
      def remember_me?
        false
      end

    end # OauthTokenAuthenticatable
  end # Strategies
end # Devise

Warden::Strategies.add(:oauth_token_authenticatable, Devise::Strategies::OauthTokenAuthenticatable)
