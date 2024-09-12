# app/controllers/properties_controller.rb
module Stay
  module Admin
    class PropertiesController < ApplicationController
      before_action :set_property, only: %i[show edit update destroy]

      def index
        @properties = Stay::Property.all
      end

      def show
      end

      def new
        @property = Stay::Property.new
      end

      def create
        @property = Stay::Property.new(property_params)
        if @property.save
          redirect_to admin_property_path(@property), notice: 'Property was successfully created.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @property.update(property_params)
          redirect_to admin_property_path(@property), notice: 'Property was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @property.destroy
        redirect_to properties_url, notice: 'Property was successfully destroyed.'
      end

      private

      def set_property
        @property = Stay::Property.find(params[:id])
      end

      def property_params
        params.require(:property).permit(:active, :title, :description, :availability_start, :availability_end, :user_id, :room_id, :address_id)
      end
    end
  end
end
