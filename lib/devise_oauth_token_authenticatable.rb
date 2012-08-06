# Originally based on:
# https://github.com/socialcast/devise_oauth2_providable/blob/master/lib/devise_oauth2_providable.rb

require 'devise'
require 'oauth2'
require 'devise/oauth_token_authenticatable/strategies/oauth_token_authenticatable_strategy'
require 'devise/oauth_token_authenticatable/models/oauth_token_authenticatable'
require 'devise/oauth_token_authenticatable/version'

module Devise
  module OauthTokenAuthenticatable
    CLIENT_ENV_REF = 'oauth2.client'
  end

  # Relative URL path to validate a given Access Token. E.g. /oauth/verify_credentials
  mattr_accessor :oauth_token_validation_url
  @@oauth_token_validation_url = nil

  # Client ID for connecting to the authentication server.
  mattr_accessor :oauth_client_id
  @@oauth_client_id = nil

  # Client Secret for connecting to the authentication server.
  mattr_accessor :oauth_client_secret
  @@oauth_client_secret = nil

  # Client options hash, passed directly to ::OAuth2::Client.new
  # From the OAuth2 documentation...
  # @param [Hash] opts the options to create the client with
  # @option opts [String] :site the OAuth2 provider site host
  # @option opts [String] :authorize_url ('/oauth/authorize') absolute or relative URL path to the Authorization endpoint
  # @option opts [String] :token_url ('/oauth/token') absolute or relative URL path to the Token endpoint
  # @option opts [Symbol] :token_method (:post) HTTP method to use to request token (:get or :post)
  # @option opts [Hash] :connection_opts ({}) Hash of connection options to pass to initialize Faraday with
  # @option opts [FixNum] :max_redirects (5) maximum number of redirects to follow
  # @option opts [Boolean] :raise_errors (true) whether or not to raise an OAuth2::Error
  #  on responses with 400+ status codes
  mattr_accessor :oauth_client_options
  @@oauth_client_options = {}

end

Devise.add_module(:oauth_token_authenticatable,
  :strategy => true,
  :model => 'devise/oauth_token_authenticatable/models/oauth_token_authenticatable'
)
