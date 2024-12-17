class Stay::Chat::QueryMessagingService
  def initialize(query, current_user)
    @query = query
    @user = current_user
    @property = @query.property
    @owner = @property.user
    @chat = @query.chat
  end

  def perform
    binding.pry

    messages_by_status = {

      "send_message" => {
       message: { text: "Query Sent for property #{@property.title} for dates #{@query.check_in_date.to_date} to #{@query.check_out_date.to_date} for #{@query.guest_count} guest." }
      },
      "booking_invitation" => {
        message: { text: "Host Invited For Booking" }
      },
      "request_change" => {
        message: { text: "Request Change in dates with stay in between #{@query.check_in_date.to_date} to #{@query.check_out_date.to_date}" }
      },
      "accepted" => {
        message: { text:  "Booking Request Sent" }
      },
      "rejected" => {
        message: { text: "Your stay at #{@property.title} from #{@query.check_in_date.to_date} to #{@query.check_out_date.to_date} is Rejected." }
      }
    }

    if messages_by_status.key?(@query.state)
      if @chat.sender_id == @user.id
        send_message(@chat, @chat.sender, messages_by_status[@query.state][:message], @owner)
      else
        send_message(@chat, @owner, messages_by_status[@query.state][:message], @chat.sender)
      end
    end
  end

  private

  def send_message(chat, sender, message_details, receiver)
    chat.messages.create!(
      body: message_details[:text],
      sender: sender,
      receiver: receiver,
      event_for: 2,
    )
  end
end
