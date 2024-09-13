module Stay
  class ApplicationController < ActionController::Base
    protect_from_forgery

    def after_sign_in_path_for(resource)
      if resource.has_stay_role?('admin')
        admin_path
      else
        root_path
      end
    end

  end
end
