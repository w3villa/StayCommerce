module Stay
  class BaseApiController < ActionController::Base
    before_action :set_active_storage_url_options
    skip_before_action :verify_authenticity_token, raise: false  
    before_action :authenticate_devise_api_token!

    private

    def set_active_storage_url_options
      ActiveStorage::Current.url_options = {host: 'localhost', port: 3000} if Rails.env.development?
    end 
  end
end
  