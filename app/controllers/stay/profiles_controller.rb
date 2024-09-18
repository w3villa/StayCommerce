class Stay::ProfilesController < Stay::BaseApiController
    before_action :set_user, only: [:show, :update]

    def new
    end
    
    def show
        render json: { profile: @profile }
    end

    def update 
        @profile.update(profile_params)
        render json: { profile: @profile }, status: :ok
    end

    private

    def set_user
        @profile = current_devise_api_user || Stay::Profile.find(params[:id])
    end

    def profile_params
        params.require(:profile).permit(:first_name, :last_name, :phone, :date_of_birth, :gender )
    end
    
end