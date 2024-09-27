module Stay
  module Admin
    class BaseController < ApplicationController
      layout "stay/admin"
      before_action :authenticate_user!
      before_action :ensure_admin, if: -> { current_user.present? }

      private

      def ensure_admin
        redirect_to root_path, alert: 'Access denied!' unless current_user.stay_admin?
      end
    end
  end
end 
