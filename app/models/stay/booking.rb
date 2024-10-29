module Stay
  class Booking < ApplicationRecord
    PAYMENT_STATES = %w(balance_due credit_owed failed paid void)
    STATUSES = %w[booking_request confirmed canceled completed].freeze

    belongs_to :user, class_name: 'Stay::User'
    belongs_to :canceler, class_name: 'Stay::User', foreign_key: "canceler_id"
    # belongs_to :room, class_name: 'Stay::Room'
    has_many :reviews, class_name: 'Stay::Review', dependent: :destroy

    has_many :payments, class_name: 'Stay::Payment', dependent: :destroy

    has_many :line_items, class_name: 'Stay::LineItem'
    has_many :rooms, through: :line_items
    # has_many :properties, through: :rooms
    belongs_to :property, class_name: "Stay::Property"
    belongs_to :store, class_name: 'Stay::Store'
    has_one :chat, class_name: 'Stay::Chat',dependent: :destroy
    has_one :invoice, dependent: :destroy

    scope :complete, -> { where.not(completed_at: nil) }
    scope :incomplete, -> { where(completed_at: nil) }
    scope :not_canceled, -> { where.not(status: 'canceled') }
    before_create :link_by_email, :generate_number
    before_validation :ensure_store_presence
    # before_commit :check_room_availblity


    accepts_nested_attributes_for :line_items, allow_destroy: true
    accepts_nested_attributes_for :payments, allow_destroy: true
    accepts_nested_attributes_for :invoice, allow_destroy: true



    validates :status, inclusion: { in: STATUSES }
    validates :number, uniqueness: true

    state_machine :status, initial: :booking_request do
      state :booking_request
      state :confirmed
      state :canceled
      state :completed

      event :confirm do
        transition booking_request: :confirmed
      end

      event :cancel do
        transition [:booking_request, :confirmed] => :canceled
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

    def total_amount
      rooms.pluck(:price_per_night).sum
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
      changes = slice(:user_id, :email, :created_by_id)

      # immediately persist the changes we just made, but don't use save
      # since we might have an invalid address associated
      self.class.unscoped.where(id: self).update_all(changes)
    end

    def generate_number
      loop do
        numeric_part = rand.to_s[2..11]
        self.number = "S#{numeric_part}"
        break unless self.class.exists?(number: number)
      end
    end

    def add_rooms_and_calculate(selected_rooms, booking_params, property)
      total_price = 0
      total_guests = 0
  
      selected_rooms.each do |room_id|
        room = property.rooms.find(room_id.to_i)
        number_of_guests = booking_params[:bookings][room_id][:number_of_guests].to_i
        price = room.price_per_night * (check_out_date - check_in_date).to_i
  
        line_items.build(room: room, quantity: number_of_guests, price: price)
  
        total_price += price
        total_guests += number_of_guests
      end
  
      self.total = total_price
      self.number_of_guests = total_guests
    end

    def ensure_store_presence
      self.store ||= Stay::Store.default
    end

    private

    def link_by_email
      self.email = user.email if user
    end
  end
end
