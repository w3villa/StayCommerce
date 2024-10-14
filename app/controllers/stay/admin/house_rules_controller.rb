module Stay
    class Admin::HouseRulesController < Stay::Admin::BaseController
    before_action :set_house_rule, only: %i[ show edit update destroy ]

    def index
      @house_rules = Stay::HouseRule.page(params[:page])
    end

    def show
    end

    def new
      @house_rule = Stay::HouseRule.new
    end

    def edit
    end

    def create
      @house_rule = Stay::HouseRule.new(house_rule_params)
      if @house_rule.save
        redirect_to admin_house_rule_path(@house_rule), notice: "House Rule was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @house_rule.update(house_rule_params)
        redirect_to admin_house_rule_path(@house_rule), notice: "House Rule was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @house_rule.destroy!
      redirect_to admin_house_rules_url, notice: "House Rule was successfully destroyed.", status: :see_other
    end

    private

    def set_house_rule
      @house_rule = Stay::HouseRule.find(params[:id])
    end

    def house_rule_params
      params.require(:house_rule).permit(:name)
    end
  end
end