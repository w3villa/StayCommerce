module Stay
  class Admin::CancellationPoliciesController < Stay::Admin::BaseController
    before_action :set_policy_type, only: %i[show edit update destroy]

    def index
      @policies = Stay::CancellationPolicy.page(params[:page])
    end

    def new
      @policy = Stay::CancellationPolicy.new
    end

    def create
      @policy = Stay::CancellationPolicy.new(policy_params)
      if @policy.save
        redirect_to admin_cancellation_policies_path, notice: "Policy successfully created."
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @policy.update(policy_params)
        redirect_to admin_cancellation_policies_path, notice: "Policy was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @policy.destroy
      redirect_to admin_cancellation_policies_path, notice: "Policy was successfully deleted."
    end

    private

    def set_policy_type
      @policy = Stay::CancellationPolicy.find(params[:id])
    end

    def policy_params
      params.require(:cancellation_policy).permit(:name, :description)
    end
  end
end
