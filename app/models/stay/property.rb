module Stay
  class Property < ApplicationRecord
    has_many :rooms, class_name: 'Stay::Room', dependent: :destroy
    has_many :chats, class_name: 'Stay::Chat', dependent: :destroy

    belongs_to :user, class_name: 'Stay::User', optional: true
    belongs_to :address, class_name: 'Stay::Address', optional: true
  end
end
