module Stay
    class Admin::AmenitiesController < Stay::Admin::BaseController
    before_action :set_amenity, only: %i[ show edit update destroy ]

    def index
      @amenities = Stay::Amenity.page(params[:page])
    end

    def show
    end

    def new
      @amenity = Stay::Amenity.new
    end

    def edit
    end

    def create
      @amenity = Stay::Amenity.new(amenity_params)

      if @amenity.save
        redirect_to admin_amenity_path(@amenity), notice: "Amenity was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @amenity.update(amenity_params)
        redirect_to admin_amenity_path(@amenity), notice: "Amenity was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @amenity.destroy!
      redirect_to admin_amenities_url, notice: "Amenity was successfully destroyed.", status: :see_other
    end

    private

    def set_amenity
      @amenity = Stay::Amenity.find(params[:id])
    end

    def amenity_params
      params.require(:amenity).permit(:name, :amenity_category_id, :amenity_type)
    end
    end
end
