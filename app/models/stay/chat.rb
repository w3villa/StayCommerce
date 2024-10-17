module Stay
  class Chat < ApplicationRecord
    belongs_to :sender, class_name: "Stay::User", foreign_key: "sender_id"
    belongs_to :receiver, class_name: "Stay::User", foreign_key: "receiver_id"
    has_many :messages, class_name: "Stay::Message", dependent: :destroy
    belongs_to :property, class_name: "Stay::Property"
    belongs_to :booking, class_name: "Stay::Booking"

    enum :chat_event, { booking_request: 0, booking_accept: 1, booking_reject: 2, booking_request_change: 3 }

    scope :between, ->(sender_id, receiver_id) do
      where("(sender_id = ? AND
          receiver_id =?) OR
          (sender_id = ? AND receiver_id =?)",
          sender_id, receiver_id, receiver_id, sender_id
      )
    end

    def chat_event_message
    end
  end
end
