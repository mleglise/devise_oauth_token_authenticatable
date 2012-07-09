# Originally based on:
# https://github.com/socialcast/devise_oauth2_providable/blob/master/lib/devise/oauth2_providable/models/oauth2_password_grantable.rb

require 'devise/models'

module Devise
  module Models
    # The OauthTokenAuthenticatable module is responsible for validating an authentication token
    # and returning basic data about the account.
    #
    # == Options
    #
    # OauthTokenAuthenticatable adds the following options to devise_for:
    #
    #   * +oauth_token_validation_url+: Defines the relative URL path to validate a given Access Token. E.g. /api/getUserInfoByAccessToken
    #   * +oauth_client_id+: Your app ID, as registered with your authentication server.
    #   * +oauth_client_secret+: Your app secret, provided by your authentication server.
    #   * +oauth_client_options+: A hash of options passed to the OAuth2::Client. Should include the 'site' param.
    #
    module OauthTokenAuthenticatable
      extend ActiveSupport::Concern

      # Hook called after oauth token authentication.
      def after_oauth_token_authentication
      end

      module ClassMethods
        def find_for_oauth_token_authentication(conditions)
          raise NotImplementedError, "You must define find_for_oauth_token_authentication in your User model"
        end

        def validate_oauth_token(token_str)
          # Make a new OAuth2 client and call the validation URL
          @@client ||= ::OAuth2::Client.new(oauth_client_id, oauth_client_secret, oauth_client_options)
          params = {                # Params for client.request
            client_id: oauth_client_id,
            access_token: token_str
          }
          access_token_opts = {}    # Params initializing AccessToken object

          opts = {}
          if @@client.options[:token_method] == :post
            headers = params.delete(:headers)
            opts[:body] = params
            opts[:headers] =  {'Content-Type' => 'application/x-www-form-urlencoded'}
            opts[:headers].merge!(headers) if headers
          else
            opts[:params] = params
          end

          response = @@client.request(@@client.options[:token_method], oauth_token_validation_url, opts)
          # Return the OAuth2::AccessToken object
          raise ::OAuth2::Error.new(response) if @@client.options[:raise_errors] && !(response.parsed.is_a?(Hash) && response.parsed['access_token'])
          ::OAuth2::AccessToken.from_hash(@@client, response.parsed.merge(access_token_opts))
        end

        Devise::Models.config(self,
          :oauth_token_validation_url,
          :oauth_client_id,
          :oauth_client_secret,
          :oauth_client_options
        )
      end

    end # OauthTokenAuthenticatable
  end # Models
end # Devise
