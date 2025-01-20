class Stay::Api::V1::PropertiesController < Stay::BaseApiController
    before_action :authenticate_devise_api_token!
    before_action :set_property, only: [ :show, :update, :destroy ]
    before_action :check_create_access, only: [ :create, :update ]
    before_action :check_update_access, only: [ :update ]

    def index
      begin
        page = params[:page].to_i > 0 ? params[:page].to_i : 1
        per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10

        cumulative_per_page = page * per_page

        @data = Stay::Property.approved.active.joins(:rooms).distinct
        @properties = @data.order(created_at: :desc).limit(cumulative_per_page)
        total_count =  @data.count
        total_pages = (total_count.to_f / per_page).ceil

        return render json: { data: "No properties found", properties: [], success: false }, status: :ok  if @properties.empty?

        render json: {
          data: "Data Found",
          properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: PropertyListingSerializer),
          success: true,
          meta: {
          total_pages: total_pages,
          current_page: page,
          next_page: page < total_pages ? page + 1 : nil,
          prev_page: page > 1 ? page - 1 : nil,
          total_count: total_count
        }
        }, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { success: false, error: "Properties not found", message: e.message }, status: :not_found
      rescue ArgumentError => e
        render json: { success: false, error: "Invalid pagination parameters", message: e.message }, status: :bad_request
      rescue StandardError => e
        render json: { success: false, error: "Internal server error", message: e.message }, status: :internal_server_error
      end
    end

    def my_properties
      begin
        page = params[:page].to_i > 0 ? params[:page].to_i : 1
        per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10

        cumulative_per_page = page * per_page
        @data =  current_devise_api_user.properties
        @properties = @data.order(created_at: :asc).limit(cumulative_per_page)
        total_count =  @data.count
        total_pages = (total_count.to_f / per_page).ceil
        return render json: { data: "No properties found", properties: [], success: false }, status: :ok  if @properties.empty?
        render json: {
          data: "Property Found",
          properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: PropertyListingSerializer),
          success: true,
          meta: {
          total_pages: total_pages,
          current_page: page,
          next_page: page < total_pages ? page + 1 : nil,
          prev_page: page > 1 ? page - 1 : nil,
          total_count: total_count
        }
        }, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { success: false, error: "Properties not found", message: e.message }, status: :not_found
      rescue ArgumentError => e
        render json: { success: false, error: "Invalid pagination parameters", message: e.message }, status: :bad_request
      rescue StandardError => e
        render json: { success: false, error: "Internal server error", message: e.message }, status: :internal_server_error
      end
    end

    def show
      render json: { data: "Data Found", property: PropertySerializer.new(@property), success: true }, status: :ok
    end

    def create
      ActiveRecord::Base.transaction do
        begin
          @property = current_devise_api_user.properties.new(property_params)
          if @property.save
            render json: { message: "Property created", property: PropertySerializer.new(@property), success: true }, status: :created
          else
            raise ActiveRecord::RecordInvalid.new(@property)
          end
        rescue ActiveRecord::RecordInvalid => e
          render json: { error: @property.errors.full_messages.to_sentence, success: false }, status: :unprocessable_entity
          raise ActiveRecord::Rollback
        rescue StandardError => e
          render json: { error: "Something went wrong: #{e.message}", success: false }, status: :unprocessable_entity
          raise ActiveRecord::Rollback
        end
      end
    end

    def update
      ActiveRecord::Base.transaction do
        if @property.update(property_params)
          render json: {
            message: "property updated",
            property: PropertySerializer.new(@property),
            success: true
          }, status: :created
        else
          raise ActiveRecord::Rollback
        end
      rescue ActiveRecord::RecordInvalid
        render json: {
          message: @property.errors.full_messages,
          success: false
        }, status: :unprocessable_entity
      end
    end

    def similar_property
      begin
        properties = Stay::Property.similar_properties(params[:property_type_id], params[:property_category_id], params[:property_id])

        if properties.exists?
          render json: {
            data: "Data Found",
            properties: ActiveModelSerializers::SerializableResource.new(properties, each_serializer: PropertyListingSerializer),
            success: true
          }, status: :ok
        else
          render json: { error: "No property found", success: false }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: { error: "No property found ", message: e.message, success: false }, status: :internal_server_error
      end
    end


    def search
      amenity_ids = parse_to_array(params[:q][:amenity_ids])
      feature_ids = parse_to_array(params[:q][:feature_ids])
      latitude, longitude = params[:q].values_at(:latitude, :longitude)

      @q = Stay::Property.approved.active.ransack(params[:q])
      @properties = @q.result.distinct

      @properties = @properties.with_amenities(amenity_ids) if amenity_ids.any?
      @properties = @properties.with_features(feature_ids) if feature_ids.any?
      @properties = @properties.nearby(latitude, longitude, params[:distance] || 10) if latitude && longitude
      @properties = @properties.by_property_type(params[:q][:property_type_id]) if params[:q][:property_type_id].present?
      @properties = @properties.price_filter(params[:q][:min_price], params[:q][:max_price]) if params[:q][:min_price] && params[:q][:max_price].present?
      @properties = @properties.by_property_category(params[:q][:property_category_id]) if params[:q][:property_category_id].present?

      @properties = @properties.page(params[:page]).per(params[:per_page] || 10)

      if @properties.any?
        render json: {
          message: "data found",
          properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: PropertyListingSerializer),
          total_pages: @properties.total_pages,
          current_page: @properties.current_page,
          next_page: @properties.next_page,
          prev_page: @properties.prev_page,
          total_count: @properties.total_count,
          success: true
        }, status: :ok
      else
        render json: { message: "No properties found" }, status: :not_found
      end
    end

    def property_tax
      @taxes = Stay::Tax.all
      if @taxes.any?
        render json: { message: "tax found", tax: @taxes, success: true }, status: :ok
      else
        render json: { message: "No properties found" }, status: :not_found
      end
    end

    def resubmit
      render json: { message: "Property resubmitted for approval", data: PropertyListingSerializer.new(@property), success: :true }, status: :ok if @property.resubmit!
      render json: { error: "Property not approved",  success: :false }, status: :unprocessable_entity
    end

    def destroy
      if @property.destroy
        render json: { message: "Property destroyed successfully", success: true }, status: :ok
      else
        render json: { error: "Property not destroyed",  success: :false }, status: :unprocessable_entity
      end
    end

    private

    def property_params
      params.require(:property).permit(:active, :title, :description, :user_id, :guest_number, :availability_start, :availability_end,  :bedroom_description, :cancellation_policy_id,
                                        :university_nearby, :about_neighbourhoods, :instant_booking, :minimum_months_of_booking, :security_deposit,
                                        :extra_guest, :allow_extra_guest, :city, :address, :latitude, :longitude, :total_rooms, :total_bathrooms, :state, :country, :zipcode, :property_state,
                                        :property_size, :property_category_id, :property_type_id, :cover_image, :price_per_month, :taxes_in_percentage, :cleaning_fee, :city_fee,
                                        :early_bird_discount, :advance_days, :is_city_fee_percentage, :unlimited_availability,  place_images: [],
                                        additional_rules_attributes: [ :id, :name,  :_destroy ],
                                        property_house_rules_attributes: [ :id, :house_rule_id, :value, :_destroy ],
                                        property_amenities_attributes: [ :id, :amenity_id, :_destroy ],
                                        property_features_attributes: [ :id, :name, :feature_id, :_destroy ],
                                        rooms_attributes: [ :id, :max_guests, :price_per_month, :status, :booking_start, :booking_end, :description, :size, :bed_type_id, :room_type_id,  :_destroy, room_images: [],
                                          room_features_attributes: [ :id, :feature_id, :_destroy ],
                                          room_amenities_attributes: [ :id, :amenity_id, :_destroy ]
                                        ],
                                        property_taxes_attributes: [ :id, :tax_id, :value, :_destroy ],
                                      )
    end

    def set_property
      begin
        @property = Stay::Property.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { success: false, error: "Properties not found" }, status: :not_found
      end
    end

    def parse_to_array(param)
      return [] unless param.present?
      param = JSON.parse(param) if param.is_a?(String)
      Array(param)
    rescue JSON::ParserError
      []
    end

  def check_create_access
    render json: { error: "You don't have access to create property", success: false }, status: :unprocessable_entity unless current_devise_api_user.stay_host?
  end

  def check_update_access
    render json: { error: "You don't have access to update this property", success: false }, status: :unprocessable_entity if current_devise_api_user != @property.user
  end
end
