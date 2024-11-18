class Stay::Chat::ChatMessagingService
  def initialize(booking)
    @booking = booking
    @user = @booking.user
    @property = @booking.property
    @owner = @property.user
    @canceler = @booking.canceler
  end

  def send_initial_messages
    unless @booking.chat.present?
      @chat = create_chat(@booking, @user, @owner, @property)
    else
      @chat = @booking.chat
    end

    messages_by_status = {
      "booking_request" => {
        user_message: { text: "Your booking request was sent for property #{@property.title} for dates #{@booking.check_in_date} to #{@booking.check_out_date}.", event: "booking request", receiver: @owner, read_at: DateTime.now },
        owner_message: { text: "You have received a new booking request for property #{@property.title} for dates #{@booking.check_in_date} to #{@booking.check_out_date}.", event: "booking request", receiver: @user, read_at: DateTime.now }
      },
      "invoice_sent" => {
        user_message: { text: "You Have received a invoice for your booking for #{@property.title} for dates #{@booking.check_in_date} to #{@booking.check_out_date}.", event: "invoice_sent", receiver: @owner, read_at: DateTime.now },
        owner_message: { text: "You have sent a new booking invoice for property #{@property.title} for dates #{@booking.check_in_date} to #{@booking.check_out_date}.", event: "invoice_sent", receiver: @user, read_at: DateTime.now }
      },
      "confirmed" => {
        user_message: { text: "Your booking for property #{@property.title} from #{@booking.check_in_date} to #{@booking.check_out_date} has been confirmed.", event: "booking confirmed", receiver: @owner, read_at: DateTime.now },
        owner_message: { text: "You have confirmed the booking for property #{@property.title} from #{@booking.check_in_date} to #{@booking.check_out_date}.", event: "booking confirmed", receiver: @user, read_at: DateTime.now }
      },
      "canceled" => {
        user_message: cancellation_message_for_user,
        owner_message: cancellation_message_for_owner
      },
      "completed" => {
        user_message: { text: "Your stay at #{@property.title} from #{@booking.check_in_date} to #{@booking.check_out_date} is complete. Thank you for staying with us!", event: "booking completed", receiver: @owner, read_at: DateTime.now },
        owner_message: { text: "The stay for property #{@property.title} from #{@booking.check_in_date} to #{@booking.check_out_date} has been completed.", event: "booking completed", receiver: @user, read_at: DateTime.now }
      }
    }

    if messages_by_status.key?(@booking.status)
      send_message(@chat, @user, messages_by_status[@booking.status][:user_message])
      send_message(@chat, @owner, messages_by_status[@booking.status][:owner_message])
    end
  end

  private

  def create_chat(booking, user, owner, property)
    Stay::Chat.create!(sender: user, receiver: owner, property: property, booking: booking)
  end

  def send_message(chat, sender, message_details)
    chat.messages.create!(
      body: message_details[:text],
      sender: sender,
      receiver: message_details[:receiver],
      event_for: sender == @user ? 1 : 0,
      event_message: message_details[:event]
    )
  end

  def cancellation_message_for_user
    if @canceler == @user
      { text: "You canceled the booking for property #{@property.title} from #{@booking.check_in_date} to #{@booking.check_out_date}.", event: "booking canceled", receiver: @owner, read_at: DateTime.now }
    else
      { text: "Your booking for property #{@property.title} from #{@booking.check_in_date} to #{@booking.check_out_date} was canceled by the host.", event: "booking canceled", receiver: @user, read_at: DateTime.now }
    end
  end

  def cancellation_message_for_owner
    if @canceler == @user
      { text: "The booking for property #{@property.title} from #{@booking.check_in_date} to #{@booking.check_out_date} was canceled by the user.", event: "booking canceled", receiver: @owner, read_at: DateTime.now }
    else
      { text: "You canceled the booking for property #{@property.title} from #{@booking.check_in_date} to #{@booking.check_out_date}.", event: "booking canceled", receiver: @user, read_at: DateTime.now }
    end
  end
end
