module Stay
  class Address < ApplicationRecord
    belongs_to :city, class_name: 'Stay::City'
    belongs_to :state, class_name: 'Stay::State'
    belongs_to :country, class_name: 'Stay::Country'
    belongs_to :user, class_name: 'Stay::Address', optional: true
    # geocoded_by :full_address
    after_validation :geocode, if: ->(obj){ obj.address1.present? && obj.zipcode.present? }

    def full_address
      [address1, address2, city.try(:name), state.try(:name), country.try(:name), zipcode].compact.join(', ')
    end
  end
end
