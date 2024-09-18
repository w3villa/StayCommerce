class Stay::PropertiesController < Stay::BaseApiController
    before_action :set_property, only: [:show]

    def index
      @properties = Stay::Property.all
      render json: { properties: @properties }
    end

    def show
      render json: { property: @property }
    end

    private

    def set_property
      @property = Stay::Property.find(params[:id])
    end
  end
