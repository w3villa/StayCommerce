module Stay
  class TaxonImage < Asset
    module Configuration
      module ActiveStorage
        extend ActiveSupport::Concern

        included do
          if Stay.public_storage_service_name
            has_one_attached :attachment, service: Stay.public_storage_service_name
          else
            has_one_attached :attachment
          end
          VALID_CONTENT_TYPES = ['image/png', 'image/jpg', 'image/jpeg'].freeze

          validates :attachment, content_type: VALID_CONTENT_TYPES

          default_scope { includes(attachment_attachment: :blob) }

          def self.styles
            @styles ||= {
              mini: '32x32>',
              normal: '128x128>'
            }
          end

          def default_style
            :mini
          end
        end
      end
    end
  end
end
