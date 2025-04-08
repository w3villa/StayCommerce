# frozen_string_literal: true
module Stay
  module ImageResizerConcern
    extend ActiveSupport::Concern

    included do
      before_action :resize_image, only: %i[update create]
    end

    private

    def resize_image
      image_params = resize_param_name
      return unless image_params
    
      Array(image_params).each do |image_param|
        next unless image_param.respond_to?(:tempfile)
    
        content_type = Marcel::MimeType.for(image_param.tempfile)
    
        next unless content_type&.start_with?("image")
    
        begin
          ImageProcessing::MiniMagick
            .source(image_param.tempfile)
            .quality(85)
            .call(destination: image_param.tempfile.path)
        rescue StandardError => e
          Rails.logger.error "Image processing failed: #{e.message}"
          next
        end
      end
    end

    def resize_param_name
      case controller_name
      when "properties"
        params[:property][:place_images] || params[:property][:cover_image]
      else
        params[:attachment]
      end
    end
  end
end
