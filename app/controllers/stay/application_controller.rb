module Stay
  class ApplicationController < ActionController::Base
    layout :set_layout

    def after_sign_in_path_for(resource)
      if resource.has_stay_role?('admin')
        admin_path
      else
        root_path
      end
    end

    private
     
    def set_layout
      if self.class.name.start_with?('Stay::Admin::')
        "stay/admin"
      else
        "stay/application"
      end
    end  
  end
end
