module Stay
  class Booking < ApplicationRecord
    PAYMENT_STATES = %w(balance_due credit_owed failed paid void)
    STATUSES = %w[pending confirmed canceled completed].freeze

    belongs_to :user, class_name: 'Stay::User'
    belongs_to :room, class_name: 'Stay::Room'

    has_many :payments, class_name: 'Spree::Payment', dependent: :destroy
    scope :complete, -> { where.not(completed_at: nil) }
    scope :incomplete, -> { where(completed_at: nil) }
    scope :not_canceled, -> { where.not(status: 'canceled') }
    before_create :link_by_email

    validates :status, inclusion: { in: STATUSES }

    state_machine :status, initial: :pending do
      state :pending
      state :confirmed
      state :canceled
      state :completed

      event :confirm do
        transition pending: :confirmed
      end

      event :cancel do
        transition [:pending, :confirmed] => :canceled
      end

      event :complete do
        transition confirmed: :completed
      end
    end

    def canceled_by(user)
      transaction do
        cancel!
        update_columns(
          canceler_id: user.id,
          canceled_at: Time.current
        )
      end
    end

    def after_cancel
      payments.completed.each(&:cancel!)
      send_cancel_email
      update(status: 'canceled', canceled_at: Time.current)
    end

    # Associates the specified user with the booking.
    def associate_user!(user, override_email = true)
      self.user           = user
      self.email          = user.email if override_email
      self.created_by   ||= user
      changes = slice(:user_id, :email, :created_by_id, :bill_address_id, :ship_address_id)

      # immediately persist the changes we just made, but don't use save
      # since we might have an invalid address associated
      self.class.unscoped.where(id: self).update_all(changes)
    end


    private

    def link_by_email
      self.email = user.email if user
    end
  end
end
