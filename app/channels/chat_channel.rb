class ChatChannel < ApplicationCable::Channel
  def subscribed
    user = params[:user]
    stream_from "ChatChannel"
    ActionCable.server.broadcast("chat_channel", { message: "Hello, world!", user: user })
  end

  def received(data)
  end

  def unsubscribed
  end
end
