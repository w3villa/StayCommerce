module Stay
  class Address < ApplicationRecord
    belongs_to :city, class_name: 'Stay::City'
    belongs_to :state, class_name: 'Stay::State'
    belongs_to :country, class_name: 'Stay::Country'
    has_many :properties, class_name: 'Stay::Property'

    def self.ransackable_attributes(auth_object = nil)
      ["city"]
    end
  end
end
