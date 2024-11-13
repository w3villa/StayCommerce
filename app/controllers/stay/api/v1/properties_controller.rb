class Stay::Api::V1::PropertiesController < Stay::BaseApiController
    before_action :set_property, only: [ :show, :update ]
    before_action :authenticate_devise_api_token!
    # before_action :check_create_access, only: [:create, :update]
    # before_action :check_update_access, only: [:update]

    def index
      begin
        page = params[:page].to_i > 0 ? params[:page].to_i : 1
        per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10

        cumulative_per_page = page * per_page

        @properties = Stay::Property.order(created_at: :desc).limit(cumulative_per_page)
        total_count =  Stay::Property.count
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

        @properties = current_devise_api_user.properties.order(created_at: :asc).limit(cumulative_per_page)
        total_count = current_devise_api_user.properties.count
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
      @property = current_devise_api_user.properties.new(property_params)
      if @property.save
        render json: { message: "property create", property: PropertySerializer.new(@property), success: true }, status: :created
      else
        render json: { message: @property.errors.full_messages, success: false }, status: :unprocessable_entity
      end
    end

    def update
      ActiveRecord::Base.transaction do
        if property_params["property_taxes_attributes"].present? &&  @property.property_taxes.any?
          property_params["property_taxes_attributes"].each do |p_tax|
            tax = @property.property_taxes.where(tax_id: p_tax["tax_id"])
            if p_tax["value"].present?
              tax.update_all(value: p_tax["value"])
            elsif p_tax["_destroy"] == "true"
              tax.destroy_all
            end
          end
        end
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

    def search
      @q = Stay::Property.approved.ransack(params[:q])
      @properties = @q.result.includes(:rooms).distinct

      if @properties.any? && params[:q][:latitude].present? && params[:q][:longitude].present?
        @properties = @properties.near([ params[:q][:latitude], params[:q][:longitude] ], params[:distance] || 10)
      end
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

    private

    def property_params
      params.require(:property).permit(:title, :description, :user_id, :guest_number, :availability_start, :availability_end,  :bedroom_description, :cancellation_policy_id,
                                        :university_nearby, :about_neighbourhoods, :instant_booking, :minimum_days_of_booking, :security_deposit,
                                        :extra_guest, :allow_extra_guest, :city, :address, :latitude, :longitude, :total_rooms, :total_bathrooms, :state, :country, :zipcode, :property_state,
                                        :property_size, :property_category_id, :property_type_id, :cover_image, :price_per_night, place_images: [],
                                        additional_rules_attributes: [ :id, :name,  :_destroy ],
                                        property_house_rules_attributes: [ :id, :house_rule_id, :value, :_destroy ],
                                        property_amenities_attributes: [ :id, :amenity_id, :_destroy ],
                                        property_features_attributes: [ :id, :name, :feature_id, :_destroy ],
                                        rooms_attributes: [ :id, :max_guests, :price_per_night, :status, :booking_start, :booking_end, :description, :size, :bed_type_id, :room_type_id,  :_destroy, room_images: [],
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

  # def check_create_access
  #   return render json:{error: "You don't have access to create property", success: false}, status: :unprocessable_entity unless current_devise_api_user.stay_host?
  # end

  # def check_update_access
  #   return render json:{error: "You don't have access to update this property", success: false}, status: :unprocessable_entity if current_devise_api_user != @property.user
  # end
end
