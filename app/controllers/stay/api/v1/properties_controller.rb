class Stay::Api::V1::PropertiesController < Stay::BaseApiController
    before_action :set_property, only: [:show]

    def index
      @properties = Stay::Property.all
      render json: { properties: @properties }
    end

    def show
      render json: { property: @property }
    end

    def search

      @q = Stay::Property.ransack(params[:q])
      @properties = @q.result.includes(address: [:city, :state, :country]).distinct

      if @properties.any?
        render json: {
          properties: @properties}, status: :ok
      else
        render json: { message: 'No properties found' }, status: :not_found
      end
    end
    private

    def set_property
      @property = Stay::Property.find(params[:id])
    end
  end
