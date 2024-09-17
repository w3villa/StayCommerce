module Stay
  module Admin
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :edit, :update, :destroy]
      
      # GET /Stay/admin/users
      def index
        @users = Stay::User.page(params[:page])
      end

      # GET /Stay/admin/users/1
      def show
      end

       # GET /Stay/admin/users/new
      def new
        @user = Stay::User.new
      end

      # GET /Stay/admin/users/1/edit
      def edit
      end

      # POST /Stay/admin/users
      # POST /Stay/admin/users.json
      def create
        @user = Stay::User.new(user_params)
        if @user.save
          redirect_to admin_user_path(@user), notice: 'User was successfully created.'
        else
          render :new
        end
      end


      # PATCH/PUT /Stay/admin/users/1
      # PATCH/PUT /Stay/admin/users/1.json
      def update
        if @user.update(user_params)
          redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
        else
          render :edit
        end
      end

      # DELETE /Stay/admin/users/1
      # DELETE /Stay/admin/users/1.json
      def destroy
        @user.destroy
        redirect_to admin_users_url, notice: 'User was successfully destroyed.'
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = Stay::User.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def user_params
          params.require(:user).permit(:first_name, :last_name, :email, :phone, :date_of_birth, :gender, :password, :password_confirmation, Stay_role_ids: [])
        end
    end
  end
end
