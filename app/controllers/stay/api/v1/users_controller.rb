class Stay::Api::V1::UsersController < Stay::BaseApiController
  before_action :set_user, only: [:destroy]

  def destroy
    if @user.destroy
      render json: { message: 'User successfully deleted' }, status: :ok
    else
      render json: { error: 'Failed to delete user' }, status: :unprocessable_entity
    end
  end
    
  private

  def set_user
    @user = Stay::User.find(params[:id])
  end
end
