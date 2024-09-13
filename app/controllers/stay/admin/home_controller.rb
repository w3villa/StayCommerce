module Stay
  module Admin
    class HomeController < ApplicationController
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
