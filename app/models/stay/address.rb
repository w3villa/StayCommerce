module Stay
  class Address < ApplicationRecord
    belongs_to :city, class_name: 'Stay::City'
    belongs_to :state, class_name: 'Stay::State'
    belongs_to :country, class_name: 'Stay::Country'
    has_many :properties, class_name: 'Stay::Property'

    belongs_to :user, class_name: 'Stay::Address', optional: true

    def self.ransackable_associations(auth_object = nil)
        ["city", "country", "properties", "state", "user"]
    end

    def self.ransackable_attributes(auth_object = nil)
      ["address1", "address2", "city_id", "state_id", "country_id"]
    end
  end
end
