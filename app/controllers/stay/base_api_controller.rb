module Stay
  class BaseApiController < ActionController::Base
    protect_from_forgery with: :null_session
    before_action :authenticate_devise_api_token!
  end
end
  