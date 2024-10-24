# app/controllers/properties_controller.rb
module Stay
  module Admin
    class PropertiesController < Stay::Admin::BaseController
      before_action :set_property, only: %i[show edit update destroy]

      def index
        @properties = current_store.properties.page(params[:page])
      end

      def show
      end

      def new
        @property = current_store.properties.build
      end

      def create
        @property = current_store.properties.build(property_params)
        if @property.save
          redirect_to admin_property_path(@property), notice: 'Property was successfully created.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        filtered_params = property_params
        filtered_params.delete(:images)  if filtered_params[:images].empty?
        if @property.update(filtered_params)
          @property.master&.update(price_per_night: @property.price_per_night)
          redirect_to admin_properties_path, notice: 'Property was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @property.destroy
        redirect_to admin_properties_url, notice: 'Property was successfully destroyed.'
      end

      private

      def set_property
        @property = current_store.properties.find_by(id: params[:id])
      end

      def property_params
        params.require(:property).permit(:active, :title, :description, :availability_start, :availability_end, :user_id, :price_per_night, images: []).tap do |params|
          # Remove any empty image string ("")
          if params[:images]
            params[:images].reject!(&:blank?)
          end
        end 
      end
    end
  end
end
