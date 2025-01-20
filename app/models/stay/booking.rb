module Stay
  class Booking < ApplicationRecord
    PAYMENT_STATES = %w[failed paid]
    STATUSES = %w[booking_request invoice_sent confirmed canceled completed].freeze

    belongs_to :user, class_name: "Stay::User"
    belongs_to :canceler, class_name: "Stay::User", foreign_key: "canceler_id", optional: true
    has_many :reviews, class_name: "Stay::Review", dependent: :destroy
    has_many :payments, class_name: "Stay::Payment", dependent: :destroy
    has_many :line_items, class_name: "Stay::LineItem", dependent: :destroy
    has_many :rooms, through: :line_items
    belongs_to :property, -> { with_deleted }, class_name: "Stay::Property", foreign_key: "property_id"
    belongs_to :store, class_name: "Stay::Store"
    has_one :chat, class_name: "Stay::Chat", dependent: :destroy
    has_one :booking_query, class_name: "Stay::BookingQuery", dependent: :destroy
    has_one :invoice, dependent: :destroy

    scope :complete, -> { where.not(completed_at: nil).where(payment_state: "paid") }
    scope :incomplete, -> { where(completed_at: nil).where(payment_state: [ "failed", nil ]).where.not(status: :canceled) }
    scope :not_canceled, -> { where.not(status: "canceled") }
    scope :confirmed, -> { where(status: "confirmed").where(payment_state: "paid") }
    
    after_commit :booking_completed_at
    before_create :link_by_email, :generate_number
    before_validation :ensure_store_presence
    before_validation :ensure_guest_count
    after_commit :booking_completed_at, if: :booking_completed?
    after_commit :update_payment_status, on: [ :update ]
    after_create :booking_room_count

    accepts_nested_attributes_for :line_items, allow_destroy: true
    accepts_nested_attributes_for :payments, allow_destroy: true
    accepts_nested_attributes_for :invoice, allow_destroy: true

    validates :status, inclusion: { in: STATUSES }
    validates :number, uniqueness: true

    state_machine :status, initial: :booking_request do
      state :booking_request
      state :invoice_sent
      state :confirmed
      state :canceled
      state :completed

      event :send_invoice do
        transition booking_request: :invoice_sent
        transition invoice_sent: :booking_request, if: :invoice_deleted?
      end

      event :confirm do
        transition invoice_sent: :confirmed
      end

      event :cancel do
        transition [ :booking_request, :confirmed ] => :canceled
      end

      event :complete do
        transition confirmed: :completed
      end
    end

    def self.ransackable_attributes(auth_object = nil)
      %w[number]
    end

    def self.ransackable_association(auth_object = nil)
      %w[user]
    end

    def update_payment_status
      update_columns(payment_state: "paid") if payments.exists?(state: "paid")
    end

    def invoice_deleted?
      invoice.nil?
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

    def booking_completed?
      completed?
    end

    def booking_completed_at
      update_columns(completed_at: Time.current)
    end

    def after_cancel
      payments.completed.each(&:cancel!)
      send_cancel_email
      update(status: "canceled", canceled_at: Time.current)
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
        price = room.price_per_month * (check_out_date - check_in_date).to_i

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

    def ensure_guest_count
      unless property.shared_property && property.allow_extra_guest
        if number_of_guests > property.guest_number
          errors.add(:number_of_guests, "can not be greater than entire property capacity")
        end
      end

      # if property.shared_property
      #   if number_of_guests < property.room.max_guests
      #     errors.add(:number_of_guests, "can not be greater than seleted property room capacity")
      #   end
      # end
    end

    def calculate_totals
      item_total = line_items.any? ? line_items.pluck(:price).sum : 0
      invoice_total = invoice.present? ? invoice.total : 0
      tax_total = property.property_taxes.any? ? property.property_taxes.uniq { |property_tax| property_tax.tax_id }.pluck(:value).sum : 0
      total_amount = item_total + invoice_total + tax_total

      if item_total != self.item_total || invoice_total != self.total || total_amount != self.total_amount
        update_columns(
          item_total: item_total,
          total: invoice_total,
          total_amount: total_amount
        )
      end
    end

    def booking_room_count
      self.update_column(:room_count, self.rooms.count)
    end

    private

    def link_by_email
      self.email = user.email if user
    end
  end
end
