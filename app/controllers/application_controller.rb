class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def gravatar_url(email)
    hashed_email = Digest::MD5.hexdigest(email)
    "http://gravatar.com/avatar/#{hashed_email}?s=30"
  end
  helper_method :gravatar_url
  
end
