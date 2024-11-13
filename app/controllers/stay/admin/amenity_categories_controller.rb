module Stay
    class Admin::AmenityCategoriesController < Stay::Admin::BaseController
    before_action :set_amenity_category, only: %i[ show edit update destroy ]

    def index
      @amenity_categories = Stay::AmenityCategory.page(params[:page])
    end

    def show
    end

    def new
      @amenity_category = Stay::AmenityCategory.new
    end

    def edit
    end

    def create
      @amenity_category = Stay::AmenityCategory.new(amenity_category_params)

      if @amenity_category.save
        redirect_to admin_amenity_category_path(@amenity_category), notice: "Amenity was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @amenity_category.update(amenity_category_params)
        redirect_to admin_amenity_category_path(@amenity_category), notice: "Amenity was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @amenity_category.destroy!
      redirect_to admin_amenity_categories_url, notice: "Amenity was successfully destroyed.", status: :see_other
    end

    private

    def set_amenity_category
      @amenity_category = Stay::AmenityCategory.find(params[:id])
    end

    def amenity_category_params
      params.require(:amenity_category).permit(:name)
    end
  end
end