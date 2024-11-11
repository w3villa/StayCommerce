module Stay
  class Message < ApplicationRecord
    belongs_to :sender, foreign_key: :sender_id, class_name: "Stay::User", optional: true
    belongs_to :receiver, foreign_key: :receiver_id, class_name: "Stay::User", optional: true
    belongs_to :chat, class_name: "Stay::Chat"
    has_many_attached :attachments
    enum :event_for, { host: 0, student: 1, both: 2}

    def read?
      read_at.present?
    end

    def attachments_urls
      attachments.map { |image| image.url }
    end
  end
end
