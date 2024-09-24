module Stay
  class City < ApplicationRecord   
    belongs_to :state, class_name: 'Stay::State', foreign_key: 'state_id'

    def self.ransackable_attributes(auth_object = nil)
      ["name"]
    end
  end
end
