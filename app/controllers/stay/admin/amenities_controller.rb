module Stay
    class Admin::AmenitiesController < Stay::Admin::BaseController
    before_action :set_amenity, only: %i[ show edit update destroy ]

    # GET /stay/amenities
    def index
      @amenities = Stay::Amenity.page(params[:page])
    end

    # GET /stay/amenities/1
    def show
    end

    # GET /stay/amenities/new
    def new
      @amenity = Stay::Amenity.new
    end

    # GET /stay/amenities/1/edit
    def edit
    end

    # POST /stay/amenities
    def create
      @amenity = Stay::Amenity.new(amenity_params)

      if @amenity.save
        redirect_to admin_amenity_path(@amenity), notice: "Amenity was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /stay/amenities/1
    def update
      if @amenity.update(amenity_params)
        redirect_to admin_amenity_path(@amenity), notice: "Amenity was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /stay/amenities/1
    def destroy
      @amenity.destroy!
      redirect_to admin_amenities_url, notice: "Amenity was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_amenity
        @amenity = Stay::Amenity.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def amenity_params
        params.require(:amenity).permit(:name, :description, :position, :active, :charge, :category)
      end
  end
end
