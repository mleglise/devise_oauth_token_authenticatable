class User < ActiveRecord::Base
  devise :database_authenticatable, :oauth_token_authenticatable
  
  def self.find_for_oauth_token_authentication(conditions)
    access_token = validate_oauth_token(conditions)
    return nil unless access_token
    
    user = User.find_or_create_by_email( access_token.params['email'] )
    
    user
  end
end
