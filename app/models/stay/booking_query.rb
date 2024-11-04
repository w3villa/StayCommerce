module Stay
  class BookingQuery < ApplicationRecord
    belongs_to :chat
    belongs_to :booking, optional: true
    belongs_to :property
    belongs_to :user
    enum state: { send_message: 0, request_change: 1, booking_invitation: 2, accepted: 3, rejected: 4 }
    after_initialize :set_default_state, if: :new_record?

    def set_default_state
      self.state ||= :send_message
    end
  
    def check_date_change
      if check_in_date_changed? || check_out_date_changed?
        self.state = :request_change
      end
    end
  end
end
