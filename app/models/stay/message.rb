module Stay
  class Message < ApplicationRecord
    belongs_to :sender, foreign_key: :sender_id, class_name: "Stay::User", optional: true
    belongs_to :receiver, foreign_key: :receiver_id, class_name: "Stay::User", optional: true
    belongs_to :chat, class_name: "Stay::Chat"
  end
end
