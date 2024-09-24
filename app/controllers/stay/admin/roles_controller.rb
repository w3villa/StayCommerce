# app/controllers/Stay/admin/role_controller.rb
module Stay
  module Admin
    class RolesController < Stay::Admin::BaseController
      before_action :set_role, only: %i[show edit update destroy]

      def index
        @roles = Stay::Role.all
      end

      def show
      end

      def new
        @role = Stay::Role.new
      end

      def create
        @role = Stay::Role.new(role_params)
        if @role.save
          redirect_to admin_role_path(@role), notice: 'Role was successfully created.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @role.update(role_params)
          redirect_to admin_role_path(@role), notice: 'Role was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @role.destroy
        redirect_to admin_roles_path, notice: 'Role was successfully destroyed.'
      end

      private

      def set_role
        @role = Stay::Role.find(params[:id])
      end

      def role_params
        params.require(:role).permit(:name)
      end
    end
  end
end
