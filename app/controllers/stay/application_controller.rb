module Stay
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    before_action :authenticate_devise_api_token!

    def after_sign_in_path_for(resource)
      if resource.has_stay_role?('admin')
        admin_path
      else
        root_path
      end
    end

  end
end
