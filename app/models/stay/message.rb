module Stay
  class Message < ApplicationRecord
    belongs_to :sender, class_name: "Stay::User"
    belongs_to :receiver, class_name: "Stay::User"
    belongs_to :chat, class_name: 'Stay::Chat'
  end
end
