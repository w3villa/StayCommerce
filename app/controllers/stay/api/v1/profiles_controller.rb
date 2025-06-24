class Stay::Api::V1::ProfilesController < Stay::BaseApiController
    before_action :set_user, only: [:show, :update]

    def show
      render json: { profile: @profile }
    end

    def update 
      if @profile.update(profile_params)
        data = ActiveModelSerializers::SerializableResource.new(@profile, serializer: UserSerializer)
        render json: { profile: data, success: true }, status: :ok
      else
        render json: { errors: @profile.errors.full_messages, success:false }, status: :unprocessable_entity
      end
    end
    
    private

    def set_user
      @profile = current_devise_api_user || Stay::User.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :phone, :date_of_birth, :gender, :profile_image, :about_me )
    end
    
end