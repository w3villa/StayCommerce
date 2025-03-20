module Stay
  module Api
    module V1
      class FavoritesController < Stay::BaseApiController
        before_action :authenticate_devise_api_token!

        def create
          @property = current_devise_api_user.favorite_properties.find_by(property_id: favorites_params[:property_id])
          return render json: { message: "favorite property already present", success: true }, status: :ok if @property
          @fav_property = current_devise_api_user.favorite_properties.new(favorites_params)
          if @fav_property.save
            render json: { message: "Favorite property added", success: true }, status: :ok
          else
            render json: { message: @fav_property.errors.full_messages.to_sentence, success: false }, status: :unprocessable_entity
          end
        end

        def index
          page = params[:page].to_i > 0 ? params[:page].to_i : 1
          per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
          cumulative_per_page = page * per_page
          @fav_properties = current_devise_api_user.favorites
          @fav_properties = @fav_properties.order(created_at: :asc).limit(cumulative_per_page)

          if @fav_properties.any?
            render json: {
              data: ActiveModelSerializers::SerializableResource.new(@fav_properties, each_serializer: PropertyListingSerializer, scope: { current_user: current_devise_api_user }),
              meta: {
                total_pages: total_pages,
                current_page: page,
                next_page: page < total_pages ? page + 1 : nil,
                prev_page: page > 1 ? page - 1 : nil,
                total_count: total_count
              },
              message: "Favorite properties found",
              success: true
            }, status: :ok
          else
            render json: { message: "No favorite properties found", success: false }, status: :not_found
          end
        end


        def destroy
          @fav_store = current_devise_api_user.favorite_properties.find_by(property_id: params[:id])
          if @fav_store
            if @fav_store.delete
              render json: { message: "property removed from favorites", success: true }, status: :ok
            else
              render json: { message: "Something went wrong", success: false }, status: :unprocessable_entity
            end
          else
            render json: { message: "property not found", success: false }, status: :not_found
          end
        end

        private

        def favorites_params
          params.require(:favorite).permit(:property_id)
        end
      end
    end
  end
end
