module Stay
  class StoreProperty < ApplicationRecord
    belongs_to :store, class_name: 'Stay::Store', touch: true
    belongs_to :property, class_name: 'Stay::Property', touch: true

    validates :store, :property, presence: true
    validates :store_id, uniqueness: { scope: :property_id }
  end
end
