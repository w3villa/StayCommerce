module Stay
  module Admin
    class PropertiesController < Stay::Admin::BaseController
      before_action :set_property, only: %i[show edit update destroy approve reject]

      def index
        @properties = current_store.properties.page(params[:page])
      end

      def show
      end

      def new
        @property = current_store.properties.build
        @step = 'description'
      end

      def create
        @property = current_store.properties.build(property_params)
        if @property.save
          redirect_to edit_admin_property_path(@property, step: determine_next_step(@step)), notice: 'Property was successfully created.'
        else
          render :new
        end
      end

      def edit
        @step = params[:step] || 'description'

        if valid_step?(@step)
          render :edit, locals: { step: @step, property: @property }
        else
          redirect_to admin_properties_path, alert: 'Invalid step.'
        end
      end

      def update
        @step = params[:step] || 'description'
        if @property.update(property_params)
          next_step = determine_next_step(@step)
          if @step == 'calender'
            redirect_to admin_properties_path, notice: 'Property was successfully updated and all steps are completed.'
          else
            redirect_to edit_admin_property_path(@property, step: next_step), notice: "Property step '#{@step}' was successfully updated. Continue to the next step."
          end
        else
          render :edit, locals: { step: @step, property: @property }
        end
      end

      def destroy
        @property.destroy
        redirect_to admin_properties_url, notice: 'Property was successfully destroyed.'
      end

      def approve
        @property.approved
        flash[:success] = "Your property has been approved!"
        redirect_to edit_admin_property_path(@property)
      end

      def reject
        @property.rejected
        flash[:success] = "Your property has been rejected!"
        redirect_to edit_admin_property_path(@property)
      end

      private

      def set_property
        @property = current_store.properties.find_by(id: params[:id])
      end

      def property_params
        params.require(:property).permit(:active, :title, :description, :availability_start, :availability_end, :address, :user_id, :property_type_id,
                                          :price_per_night, :property_category_id, :guest_number, :country_id, :state_id, :bedroom_description,
                                          :university_nearby, :about_neighbourhoods, :instant_booking, :minimum_days_of_booking, :security_deposit, 
                                          :extra_guest, :allow_extra_guest, :city, :total_bedrooms, :latitude, :longitude, :total_rooms, :country, :state,
                                          :total_bathrooms, :property_size, :cover_image, :zipcode, amenity_ids: [], feature_ids: [],
                                          property_taxes_attributes: [:id, :tax_id, :value, :_destroy],
                                          property_amenities_attributes: [:id, :property_id, :amenity_id, :_destroy],
                                          property_features_attributes: [:id, :name, :feature_id, :_destroy],
                                          additional_rules_attributes: [:id, :name, :property_id, :_destroy],
                                          rooms_attributes: [:id, :property_id, :max_guests, :price_per_night, :room_type_id, :status, :is_master, :booking_start, :booking_end, :description, :size, :bed_type_id, :_destroy],
                                          property_house_rules_attributes: [:id, :property_id, :house_rule_id, :value, :_destroy]
                                        )
      end


      def determine_next_step(current_step)
        case current_step
        when 'description'
          'price'
        when 'price'
          'images'
        when 'images'
          'details'
        when 'details'
          'location'
        when 'location'
          'amenities'
        when 'amenities'
          'features'
        when 'features'
          'calender'
        else
          'description'
        end
      end

      def valid_step?(step)
        %w[description price images details location amenities features calender].include?(step)
      end
    end
  end
end
