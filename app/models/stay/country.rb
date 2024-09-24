module Stay
  class Country < ApplicationRecord
    has_many :addresses
    has_many :states, class_name: 'Stay::State', dependent: :destroy

    def self.ransackable_attributes(auth_object = nil)
      ["name"]
    end

  end
end
