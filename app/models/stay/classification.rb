module Stay
  class Classification < ApplicationRecord
    self.table_name = 'stay_properties_taxons'
    acts_as_list scope: :taxon

    with_options inverse_of: :classifications, touch: true do
      belongs_to :property, class_name: 'Stay::Property' # Corrected to 'Stay::Property'
      belongs_to :taxon, class_name: 'Stay::Taxon'
    end

    validates :taxon, :property, presence: true # Ensure to validate property instead of product
    validates :taxon_id, uniqueness: { scope: :property_id, message: :already_linked, allow_blank: true }

    self.whitelisted_ransackable_attributes = ['taxon_id', 'property_id']
  end
end
