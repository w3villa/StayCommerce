module Stay
  class Admin::PropertyTypesController < Stay::Admin::BaseController
    before_action :set_property_type, only: %i[show edit update destroy]

    def index
      @property_types = Stay::PropertyType.page(params[:page])
    end

    def new
      @property_type = Stay::PropertyType.new
    end

    def create
      @property_type = Stay::PropertyType.new(property_type_params)
      if @property_type.save
        redirect_to admin_property_types_path, notice: 'Property Type was successfully created.'
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @property_type.update(property_type_params)
        redirect_to admin_property_types_path, notice: 'Property Type was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @property_type.destroy
      redirect_to admin_property_types_path, notice: 'Property Type was successfully deleted.'
    end

    private

    def set_property_type
      @property_type = Stay::PropertyType.find(params[:id])
    end

    def property_type_params
      params.require(:property_type).permit(:name)
    end
  end
end
