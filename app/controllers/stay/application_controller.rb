module Stay
  class ApplicationController < ActionController::Base
    include Rails.application.routes.url_helpers
    protect_from_forgery
    layout :set_layout
    protect_from_forgery with: :null_session
    before_action :set_active_storage_url_options
    # before_action :authenticate_devise_api_token!
    before_action :authorize_admin

  

    def after_sign_in_path_for(resource)
      if resource.has_stay_role?('admin')
        admin_users_path
      else
        root_path
      end
    end



    private

    def authorize_admin
      unless current_user&.stay_admin?
        flash[:alert] = "You are not authorized to access this section."
        redirect_to root_path
      end
    end
     
    def set_layout
      if self.class.name.start_with?('Stay::Admin::')
        "stay/admin"
      else
        "stay/application"
      end
    end

    def set_active_storage_url_options
      ActiveStorage::Current.url_options = {host: 'localhost', port: 3000} if Rails.env.development?
    end  
  end
end
