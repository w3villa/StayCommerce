module Stay
  module Admin
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :edit, :update, :destroy, :addresses]
      
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

      def addresses
        if request.put?
          params[:user][:addresses_attributes][:user_id] = @user.id if params[:user][:addresses_attributes].present?
          if @user.update(user_params)
            flash[:success] = 'Address updated successfully'
            redirect_to admin_user_path(@user)
          else
            flash.now[:error] = 'Failed to update address'
            render :addresses, status: :unprocessable_entity
          end
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = Stay::User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(:first_name, :last_name, :email, :phone, :date_of_birth, :gender, :password, :password_confirmation, stay_role_ids: [], addresses_attributes: [:id, :address1, :address2, :city, :state, :country, 
                                :zipcode, :longitude, :latitude, :city_id, :state_id, :country_id])
        end
    end
  end
end
