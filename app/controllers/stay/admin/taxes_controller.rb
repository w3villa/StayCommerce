module Stay
  class Admin::TaxesController < Stay::Admin::BaseController
    before_action :set_tax, only: %i[show edit update destroy]

    def index
      @taxes = Stay::Tax.page(params[:page])
    end

    def new
      @tax = Stay::Tax.new
    end

    def create
      @tax = Stay::Tax.new(tax_params)
      if @tax.save
        redirect_to admin_taxes_path, notice: 'Tax was successfully created.'
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @tax.update(tax_params)
        redirect_to admin_taxes_path, notice: 'Tax was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @tax.destroy
      redirect_to admin_taxes_path, notice: 'Tax was successfully deleted.'
    end

    private

    def set_tax
      @tax = Stay::Tax.find(params[:id])
    end

    def tax_params
      params.require(:tax).permit(:name)
    end
  end
end
