module Stay
  module Admin
    class FeaturesController < Stay::Admin::BaseController
      before_action :set_feature, only: [:show, :edit, :update, :destroy]

      
      def index
        @features = Stay::Feature.all
      end

      def show
      end

      def new
        @feature = Stay::Feature.new
      end

      def create
        @feature = Stay::Feature.new(feature_params)
        if @feature.save
          redirect_to admin_features_path, notice: 'Feature was successfully created.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @feature.update(feature_params)
          redirect_to admin_features_path, notice: 'Feature was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @feature.destroy
        redirect_to admin_features_path, notice: 'Feature was successfully deleted.'
      end

      private

      def set_feature
        @feature = Stay::Feature.find(params[:id])
      end

      def feature_params
        params.require(:feature).permit(:name, :feature_type)
      end
    end
  end
end
