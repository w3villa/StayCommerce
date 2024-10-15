module Stay
  class Admin::PropertyCategoriesController < Stay::Admin::BaseController
    before_action :set_property_category, only: %i[show edit update destroy]

    def index
      @property_categories = Stay::PropertyCategory.page(params[:page])
    end

    def new
      @property_category = Stay::PropertyCategory.new
    end

    def create
      @property_category = Stay::PropertyCategory.new(property_category_params)
      if @property_category.save
        redirect_to admin_property_categories_path, notice: 'Property Category was successfully created.'
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @property_category.update(property_category_params)
        redirect_to admin_property_categories_path, notice: 'Property Category was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @property_category.destroy
      redirect_to admin_property_categories_path, notice: 'Property Category was successfully deleted.'
    end

    private

    def set_property_category
      @property_category = Stay::PropertyCategory.find(params[:id])
    end

    def property_category_params
      params.require(:property_category).permit(:name, :property_type_id, :room_type_id)
    end
  end
end
