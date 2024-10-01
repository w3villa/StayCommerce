module Stay
  class ApplicationController < ActionController::Base
    include Rails.application.routes.url_helpers
    include CurrencyHelper
    helper Stay::Admin::StoresHelper
    include LocaleHelper

    protect_from_forgery
    layout "stay/application"
    protect_from_forgery with: :null_session
    before_action :set_active_storage_url_options
    before_action :set_locale
    # before_action :authenticate_devise_api_token!
    # before_action :authorize_admin
    helper_method :current_store
  

    def after_sign_in_path_for(resource)
      if resource.has_stay_role?('admin')
        admin_users_path
      else
        root_path
      end
    end

    def current_store
      @current_store ||= Stay::Store.default
    end

    private

    def set_active_storage_url_options
      ActiveStorage::Current.url_options = {host: 'localhost', port: 3000} if Rails.env.development?
    end  

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end
  end
end
