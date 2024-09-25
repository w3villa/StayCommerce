module Stay
  module Admin
    class CountriesController < Stay::Admin::BaseController
      before_action :set_country, only: [:edit, :update, :destroy]

      def index
        @countries = Stay::Country.all
      end

      def new
        @country = Stay::Country.new
      end

      def create
        @country = Stay::Country.new(country_params)
        if @country.save
          redirect_to admin_countries_path, notice: 'Country was successfully created.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @country.update(country_params)
          redirect_to admin_countries_path, notice: 'Country was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @country.destroy
        redirect_to admin_countries_path, notice: 'Country was successfully deleted.'
      end

      def states
        @states = Stay::State.where(country_id: params[:id])
        render json: @states
      end
      
      private

      def set_country
        @country = Stay::Country.find(params[:id])
      end

      def country_params
        params.require(:country).permit(:name, :iso_name, :iso, :iso3, :states_required)
      end
    end
  end
end