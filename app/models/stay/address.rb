module Stay
  class Address < ApplicationRecord
    belongs_to :city, class_name: 'Stay::City'
    belongs_to :state, class_name: 'Stay::State'
    belongs_to :country, class_name: 'Stay::Country'
    belongs_to :user, class_name: 'Stay::Address', optional: true
  end
end
