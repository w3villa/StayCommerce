module Stay
  class Payment < ApplicationRecord
    belongs_to :booking, class_name: 'Stay::Booking'
    belongs_to :payment_method, class_name: 'Stay::PaymentMethod'
    belongs_to :source, polymorphic: true 

    validates :payment_method, presence: true
    validates :amount, numericality: true

    scope :with_state, ->(s) { where(state: s.to_s) }
    scope :completed, -> { with_state('completed') }
    scope :pending, -> { with_state('pending') }
    scope :processing, -> { with_state('processing') }
    scope :failed, -> { with_state('failed') }

    state_machine initial: :checkout do
      # to complete
      event :started_processing do
        transition from: [:checkout, :pending, :completed, :processing], to: :processing
      end
      # When processing during checkout fails
      event :failure do
        transition from: [:pending, :processing], to: :failed
      end
      # With card payments this represents authorizing the payment
      event :pend do
        transition from: [:checkout, :processing], to: :pending
      end
      # With card payments this represents completing a purchase or capture transaction
      event :complete do
        transition from: [:processing, :pending, :checkout], to: :completed
      end
      after_transition to: :completed, do: :after_completed
      event :void do
        transition from: [:pending, :processing, :completed, :checkout], to: :void
      end
      after_transition to: :void, do: :after_void
      # when the card brand isn't supported
      event :invalidate do
        transition from: [:checkout], to: :invalid
      end

      after_transition do |payment, transition|
        payment.state_changes.create!(
          previous_state: transition.from,
          next_state: transition.to,
          name: 'payment'
        )
      end
    end
  end
end
