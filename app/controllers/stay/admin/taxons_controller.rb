module Stay
  module Admin
    class TaxonsController < Stay::Admin::BaseController
      include Translatable

      before_action :set_taxonomy, only: [:new, :create, :edit, :update, :remove_icon]
      before_action :set_taxon, only: [:edit, :update, :remove_icon]
      before_action :set_permalink_part, only: [:edit]
      respond_to :html, :js

      def index
        @taxons = @taxonomy.taxons.roots
      end


      def new
        @taxon = @taxonomy.taxons.build
      end

      def create
        @taxon = @taxonomy.taxons.build(taxon_params)

        successful = @taxon.transaction do
          set_position
          set_parent(params[:taxon][:parent_id])

          if @taxon.save
            regenerate_permalink if params[:taxon][:parent_id]

            flash[:success] = "successfully created"
            respond_with(@taxon) do |format|
              format.html { redirect_to edit_admin_taxonomy_taxon_path(@taxonomy.id, @taxon.id) }
              format.json { render json: @taxon.to_json, status: :created }
            end
          else
            respond_with(@taxon) do |format|
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @taxon.errors.full_messages.to_sentence, status: :unprocessable_entity }
            end
          end
        end
        unless successful
          respond_with(@taxon) do |format|
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @taxon.errors.full_messages.to_sentence, status: :unprocessable_entity }
          end
        end
      end

      def update
        # Ensure @taxon is set before using it
        @taxon = @taxonomy.taxons.find(params[:id])

        successful = @taxon.transaction do
          parent_id = params[:taxon][:parent_id]
          set_position
          set_parent(parent_id)

          @taxon.save!
          regenerate_permalink if parent_id

          set_permalink_params
          @update_children = true if params[:taxon][:name] != @taxon.name || params[:taxon][:permalink] != @taxon.permalink

          @taxon.create_icon(attachment: taxon_params[:icon]) if taxon_params[:icon]
          @taxon.update(taxon_params.except(:icon))
        end

        if successful
          flash[:success] = "successfully updated"

          # rename child taxons
          rename_child_taxons if @update_children

          respond_with(@taxon) do |format|
            format.html { redirect_to edit_admin_taxonomy_taxon_path(@taxonomy.id, @taxon.id) }
            format.json { render json: @taxon.to_json }
          end
        else
          respond_with(@taxon) do |format|
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @taxon.errors.full_messages.to_sentence, status: :unprocessable_entity }
          end
        end
      end

      def edit
        @taxon = @taxonomy.taxons.find_by(id: params[:id])

        respond_to do |format|
          format.html
          format.json { render json: @taxon }
        end
      end

      def remove_icon
        if @taxon.icon.destroy
          flash[:success] = t('notice_messages.icon_removed')
          redirect_to edit_admin_taxonomy_taxon_url(@taxonomy.id, @taxon.id)
        else
          flash[:error] = t('errors.messages.cannot_remove_icon')
          render :edit, status: :unprocessable_entity
        end
      end

      # This method is added here to allow `edit_polymorphic_path` to work
      def edit_admin_taxon_path(taxon)
        edit_admin_taxonomy_taxon_path(taxon.taxonomy, taxon.id)
      end

      private

      def location_after_save
        edit_admin_taxonomy_taxon_path(@taxonomy.id, @taxon.id)
      end

      def parent_data
        if action_name == 'index'
          nil
        else
          super
        end
      end

      def set_taxon
        @taxon = @taxonomy.taxons.find_by(id: params[:id])
        unless @taxon
          flash[:error] = "Taxon not found"
          redirect_to some_safe_path # handle not found
        end
      end
      # def set_permalink_part
      #   @permalink_part = @taxon.permalink.split('/').last
      #   @parent_permalink = @taxon.permalink.split('/')[0...-1].join('/')
      #   @parent_permalink += '/' unless @parent_permalink.blank?
      # end


      def set_permalink_part
          @permalink_part = @taxon.permalink.split('/').last
          @parent_permalink = @taxon.permalink.split('/')[0...-1].join('/')
          @parent_permalink += '/' unless @parent_permalink.blank?
      end


      def set_taxonomy
        @taxonomy = Stay::Taxonomy.find(params[:taxonomy_id])
      end


      def set_position
        new_position = params[:taxon][:position]
        @taxon.child_index = new_position.to_i if new_position
      end

      def set_parent(parent_id)
        @taxon.parent = current_store.taxons.find(parent_id) if parent_id
      end

      def set_permalink_params
        set_permalink_part

        if params.key? 'permalink_part'
          params[:taxon][:permalink] = @parent_permalink + params[:permalink_part]
        end
      end

      def rename_child_taxons
        @taxon.descendants.each do |taxon|
          reload_taxon_and_set_permalink(taxon)
        end
      end

      def regenerate_permalink
        reload_taxon_and_set_permalink(@taxon)
        @update_children = true
      end

      def reload_taxon_and_set_permalink(taxon)
        taxon.reload
        taxon.set_permalink
        taxon.save!
      end

      def scope
        current_store.taxonomies
      end

      def taxon_params
        params.require(:taxon).permit(:name, :parent_id, :position, :icon, :description, :permalink, :hide_from_nav, :taxonomy_id, :meta_description, :meta_keywords, :meta_title, :child_index)
      end
    end
  end
end
