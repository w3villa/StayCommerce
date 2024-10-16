module Stay
  module Admin
    class TaxonomiesController < Stay::Admin::BaseController
      before_action :load_taxonomy, only: [:edit, :update, :destroy]

      def index
        @taxonomies = Stay::Taxonomy.all
      end

      def new
        @taxonomy = Stay::Taxonomy.new
      end

      def create
        @taxonomy = Stay::Taxonomy.new(taxonomy_params)
        @object = @taxonomy
        set_current_store
        if @taxonomy.save
          flash[:success] = 'Taxonomy created successfully.'
          redirect_to admin_taxonomies_path
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @taxonomy.update(taxonomy_params)
          set_current_store
          flash[:success] = 'Taxonomy updated successfully.'
          redirect_to admin_taxonomies_path
        else
          render :edit
        end
      end

      def destroy
        @taxonomy.destroy
        flash[:success] = 'Taxonomy deleted successfully.'
        redirect_to admin_taxonomies_path
      end

      private

      def load_taxonomy
        @taxonomy = Stay::Taxonomy.find(params[:id])
      end

      def taxonomy_params
        params.require(:taxonomy).permit(:name, :position, :store_id)
      end
    end
  end
end
