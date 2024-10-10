# app/controllers/stay/admin/stores_controller.rb
module Stay
  module Admin
    class StoresController < Stay::Admin::BaseController
      helper Stay::LocaleHelper 
      before_action :load_store, only: [:new, :edit, :update]
      before_action :set_default_currency, only: :new
      before_action :set_default_locale, only: :new
      before_action :normalize_supported_currencies, only: [:create, :update]
      before_action :normalize_supported_locales, only: [:create, :update]
      before_action :set_default_country_id, only: :new
      before_action :load_all_countries, only: [:new, :edit, :update, :create]
      # before_action :load_all_zones, only: [:new, :edit, :update, :create]
      before_action :set_store, only: [:show, :edit, :update, :destroy, :set_default]

      # GET /admin/stores
      def index
        @stores = Stay::Store.all
      end

      # GET /admin/stores/new
      def new
        @store = Stay::Store.new
      end

      # POST /admin/stores
      def create
        @store = Stay::Store.new(store_params)

        if @store.save
          flash[:success] = "Store created successfully"
          redirect_to admin_url, allow_other_host: true
        else
          flash.now[:error] = "Unable to create store."
          render :new
        end
      end

      # GET /admin/stores/:id/edit
      def edit
      end

      def show
      end

      # PATCH/PUT /admin/stores/:id
      def update
        if @store.update(store_params)
          flash[:success] = "Store Update Successfully"
          redirect_to admin_stores_path
        else
          flash.now[:error] = "Unable to update store."
          render :edit
        end
      end

      # DELETE /admin/stores/:id
      def destroy
        if @store.destroy
          flash[:success] = "Store deleted successfully."
        else
          flash[:error] = "Failed to delete the store. Please try again."
        end
        redirect_to admin_stores_path
      end

      def set_default
        Stay::Store.update_all(default: false)
        if @store.update(default: true)
          redirect_to admin_stores_path, notice: 'Store successfully set as default.'
        else
          redirect_to admin_stores_path, alert: 'Failed to set store as default.'
        end
      end

      private

      def set_store
        @store = Stay::Store.find(params[:id])
      end

      def store_params
        params.require(:store).permit(:name, :url, :seo_title, :code, :meta_keywords,
                          :meta_description, :default_currency, :mail_from_address,
                          :customer_support_email, :facebook, :twitter, :instagram,
                          :description, :address, :contact_phone, :supported_locales,
                          :default_locale, :default_country_id, :supported_currencies,
                          :new_order_notifications_email, :checkout_zone_id, :seo_robots,
                          :digital_asset_authorized_clicks, :digital_asset_authorized_days,
                          :limit_digital_download_count, :limit_digital_download_days, :digital_asset_link_expire_time,
                          { mailer_logo_attributes: {}, favicon_image_attributes: {}, logo_attributes: {} })
      end

      def load_store
        @store = stores_scope.find_by(id: params[:id]) || stores_scope.new
      end

      def load_all_countries
        @countries = Stay::Country.pluck(:name, :id)
      end

      def set_default_currency
        @store.default_currency = Stay::Store.default.default_currency
      end

      def set_default_locale
        @store.default_locale = I18n.locale
      end

      def normalize_supported_currencies
        if params[:store][:supported_currencies]&.is_a?(Array)
          params[:store][:supported_currencies] = params[:store][:supported_currencies].compact.uniq.reject(&:blank?).join(',')
        end
      end

      def normalize_supported_locales
        if params[:store][:supported_locales]&.is_a?(Array)
          params[:store][:supported_locales] = params[:store][:supported_locales].compact.uniq.reject(&:blank?).join(',')
        end
      end

      def set_default_country_id
        @store.default_country_id ||= Stay::Store.default.default_country_id || Stay::Country.find_by(iso: "US")&.id
      end

      def save_translation_values
        @object = @store
        super
      end
    end
  end
end
