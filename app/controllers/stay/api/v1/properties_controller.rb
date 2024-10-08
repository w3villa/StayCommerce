class Stay::Api::V1::PropertiesController < Stay::BaseApiController
    before_action :set_property, only: [:show, :update]

    def index
      begin
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 10).to_i
        @properties = Stay::Property.page(page).per(per_page)
        return render json: { data: "No properties found", properties: [], success: false}, status: :ok  if @properties.empty?
        render json: {
          data: "Data Found",
          properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: PropertyListingSerializer),
          success: true,
          meta: {
            current_page: @properties.current_page,
            total_pages: @properties.total_pages,
            total_count: @properties.total_count
          }
        }, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { success: false, error: 'Properties not found', message: e.message }, status: :not_found
      rescue ArgumentError => e
        render json: { success: false, error: 'Invalid pagination parameters', message: e.message }, status: :bad_request
      rescue StandardError => e
        render json: { success: false, error: 'Internal server error', message: e.message }, status: :internal_server_error
      end
    end
    

    def show
      render json: {data: "Data Found",property:PropertySerializer.new(@property), success: true}, status: :ok
    end

    def create
      @property = current_devise_api_user.properties.new(property_params)
      if @property.save
        render json: {message: "property create", property:PropertySerializer.new(@property) , success: true}, status: :created
      else
        render json: {message: @property.errors.full_messages, success: false}, status: :unprocessable_entity
      end
    end

    def update
      if @property.update(property_params)
        render json: {message: "property updated", property:PropertySerializer.new(@property),success: true}, status: :created
      else
        render json: {message: @property.errors.full_messages, success: false}, status: :unprocessable_entity
      end
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

    def property_params
      params.require(:property).permit( :title, :description, :user_id, :guest_number, :availability_start, :availability_end,  :bedroom_description,
                                        :university_nearby, :about_neighbourhoods, :instant_booking, :minimum_days_of_booking, :security_deposit, 
                                        :extra_guest, :allow_extra_guest, :city, :address, :latitude, :longitude, :total_rooms ,:total_bathrooms,
                                        :property_size, :property_category_id, :cover_image, :price_per_night, place_images: [],
                                        additional_rules_attributes: [:id, :name,  :_destroy],
                                        property_house_rules_attributes: [:id, :house_rule_id, :value, :_destroy], 
                                        property_amenities_attributes: [:id, :amenity_id, :_destroy],
                                        rooms_attributes: [:id, :max_guests, :price_per_night, :status, :booking_start, :booking_end, :description, :size, :bed_type_id, :room_type_id ]
                                      )
    end

    def set_property
      begin
        @property = Stay::Property.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { success: false, error: 'Properties not found' }, status: :not_found
      end
    end

  end
