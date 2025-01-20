class Stay::Chat::QueryMessagingService
  def initialize(query, current_user, message = nil)
    @query = query
    @user = current_user
    @property = @query.property
    @owner = @property.user
    @chat = @query.chat
    @message = message
  end

  def perform
    messages_by_status = {
      "send_message" => {
        user_message: { text: "#{@message} You have raised a request for the property #{@property.title} for dates #{formatted_date(@query.check_in_date.to_date)} to #{formatted_date(@query.check_out_date.to_date)} for #{@query.guest_count} guest(s).", event: "booking query", receiver: @owner },
        owner_message: { text: "#{@message} A booking query has been received for the property #{@property.title} for dates #{formatted_date(@query.check_in_date.to_date)} to #{formatted_date(@query.check_out_date.to_date)} for #{@query.guest_count} guest(s).", event: "booking query", receiver: @user }
      },
      "booking_invitation" => {
        user_message: { text: "You have received a booking invitation.", event: "booking invitation", receiver: @owner },
        owner_message: { text: "You have sent a booking invitation.", event: "booking invitation", receiver: @user }
      },
      "request_change" => {
      user_message: { text: "You have requested a change in booking dates to #{formatted_date(@query.check_in_date.to_date)} - #{formatted_date(@query.check_out_date.to_date)}.", event: "request change", receiver: @owner },
        owner_message: { text: "The user has requested a change in booking dates to #{formatted_date(@query.check_in_date.to_date)} - #{formatted_date(@query.check_out_date.to_date)}.", event: "request change", receiver: @user }
      },
      "accepted" => {
        user_message: { text: "You have sent a booking request.", event: "booking accepted", receiver: @owner },
        owner_message: { text: "You have received a booking request.", event: "booking accepted", receiver: @user }
      },
      "rejected" => {
        user_message: { text: "The booking for #{@property.title} from #{formatted_date(@query.check_in_date.to_date)} to #{formatted_date(@query.check_out_date.to_date)} has been rejected.", event: "booking rejected", receiver: @owner },
        owner_message: { text: "The booking for #{@property.title} from #{formatted_date(@query.check_in_date.to_date)} to #{formatted_date(@query.check_out_date.to_date)} has been rejected.", event: "booking rejected", receiver: @user }
      }
    }

    if messages_by_status.key?(@query.state)
      messages = messages_by_status[@query.state]
      send_message(@chat, @user, messages[:user_message], @owner)
      send_message(@chat, @owner, messages[:owner_message], @user)
    end
  end

  private

  def send_message(chat, sender, message_details, receiver)
    chat.messages.create!(
      body: message_details[:text],
      sender: sender,
      receiver: receiver,
      event_for: sender == @user ? 1 : 0,
    )
  end

  def formatted_date(date)
    date.strftime("%B %d, %Y") if date.present?
  end
end
