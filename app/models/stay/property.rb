module Stay
  class Property < ApplicationRecord
    has_many :rooms, class_name: 'Stay::Room', dependent: :destroy
    has_many :chats, class_name: 'Stay::Chat', dependent: :destroy

    belongs_to :user, class_name: 'Stay::User', optional: true
    belongs_to :address, class_name: 'Stay::Address', optional: true

    def self.ransackable_attributes(auth_object = nil)
      ["id", "name", "created_at", "updated_at"]
    end
  
    def self.ransackable_associations(auth_object = nil)
      ["address"]
    end
  end
end
