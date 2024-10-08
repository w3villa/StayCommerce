class Stay::Api::V1::PropertiesController < Stay::BaseApiController
    before_action :set_property, only: [:show, :update]

    def index
      @properties = Stay::Property.all
      render json: { properties: @properties }
    end

    def show
      render json: { property:PropertySerializer.new(@property) }
    end

    def create
      @property = Stay::Property.new(property_params)
      if @property.save
        render json: {message: "property create", property: @property , success: true}, status: :created
      else
        render json: {message: @property.errors.full_messages, success: false}, status: :unprocessable_entity
      end
    end

    def update
      if @property.update(property_params)
        render json: {message: "property updated", success: true}, status: :created
      else
        render json: {message: @property.errors.full_messages, success: false}, status: :unprocessable_entity
      end
    end

    def search
      binding.pry
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

    def property_params
      params.require(:property).permit( :title, :description, :user_id, :guest_number, :availability_start, :availability_end,  :bedroom_description,
                                        :university_nearby, :about_neighbourhoods, :instant_booking, :minimum_days_of_booking, :security_deposit, 
                                        :extra_guest, :allow_extra_guest, :city, :address, :latitude, :longitude, :total_rooms ,:total_bathrooms,
                                        :property_size, :property_category_id, :cover_image,
                                        additional_rules_attributes: [:id, :name,  :_destroy],
                                        property_house_rules_attributes: [:id, :house_rule_id, :_destroy], 
                                        property_amenities_attributes: [:id, :amenity_id, :_destroy],
                                        rooms_attributes: [:id, :max_guests, :price_per_night, :status, :booking_start, :booking_end, :description, :size, :bed_type_id, :room_type_id ]
                                      )
    end

    def set_property
      @property = Stay::Property.find(params[:id])
    end

    def check_user
      binding.pry
    end
  end
