module Stay
  module Admin
    class BaseController < ApplicationController
      include Stay::ControllerHelpers::Currency
      include Stay::ControllerHelpers::Store
      layout "stay/admin"
      before_action :authenticate_user!
      before_action :ensure_admin, if: -> { current_user.present? }
      before_action :load_stores

      def stores_scope
        Stay::Store.includes(:translations)
      end

      def load_stores
        @stores = stores_scope.order(default: :desc)
      end

      def set_current_store
        return if @object.nil?

        ensure_current_store(@object)
      end

      def set_currency
        return if @object.nil?

        @object.currency = current_currency if model_class.method_defined?(:currency=)
      end

      private

      def ensure_admin
        redirect_to root_path, alert: 'Access denied!' unless current_user.stay_admin?
      end
    end
  end
end 
