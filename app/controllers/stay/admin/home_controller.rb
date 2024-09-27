module Stay
  module Admin
    class HomeController < Stay::Admin::BaseController
      skip_before_action :authenticate_user!

      def index
        if user_signed_in?
          redirect_to admin_users_path
        else
          redirect_to admin_login_path
        end
      end
    end
  end
end
