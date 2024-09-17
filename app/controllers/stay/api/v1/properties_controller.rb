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

      @search = Stay::Property.joins(:address).ransack(
        address_city_name_cont: params[:q]
      )
      
      # Fetch results with pagination
      @properties = @search.result.page(params[:page]).per(20)
  
  # 
      
      properties = properties = Stay::Property.joins(:address).ransack(address_city_cont: params[:q]).result


      if properties.any?
        render json: {
          properties: properties}, status: :ok
      else
        render json: { message: 'No properties found' }, status: :not_found
      end
    end
    private

    def set_property
      @property = Stay::Property.find(params[:id])
    end
  end
