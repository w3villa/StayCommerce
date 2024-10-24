module Stay
  class Admin::BedTypesController < Stay::Admin::BaseController
    before_action :set_bed_type, only: %i[show edit update destroy]

    def index
      @bed_types = Stay::BedType.page(params[:page])
    end

    def new
      @bed_type = Stay::BedType.new
    end

    def create
      @bed_type = Stay::BedType.new(bed_type_params)
      if @bed_type.save
        redirect_to admin_bed_types_path, notice: 'Bed type was successfully created.'
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @bed_type.update(bed_type_params)
        redirect_to admin_bed_types_path, notice: 'Bed type was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @bed_type.destroy
      redirect_to admin_bed_types_path, notice: 'Bed type was successfully deleted.'
    end

    private

    def set_bed_type
      @bed_type = Stay::BedType.find(params[:id])
    end

    def bed_type_params
      params.require(:bed_type).permit(:name)
    end
  end
end
