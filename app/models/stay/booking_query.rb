module Stay
  class BookingQuery < ApplicationRecord
    ACCEPTED = "accepted".freeze
    belongs_to :chat
    belongs_to :booking, optional: true
    belongs_to :property
    belongs_to :user
    enum :state, { send_message: 0, request_change: 1, booking_invitation: 2, accepted: 3, rejected: 4 }
    after_initialize :set_default_state, if: :new_record?
    scope :ongoing, -> { where.not(state: ACCEPTED) }
    scope :date_range, ->(check_in, check_out) { where(check_in_date: check_in, check_out_date: check_out) }
    scope :without_booking, -> { where(booking_id: nil) }
    scope :for_current_user, ->(user) { where(user: user) }

    def set_default_state
      self.state ||= :send_message
    end

    def check_date_change
      self.state = :request_change if check_in_date_changed? || check_out_date_changed?
    end
  end
end
