module Stay
  module Admin
    class MessagesController < Stay::Admin::BaseController
      before_action :set_message, only: %i[show edit update destroy]

      def index
        @messages = Stay::Message.all
      end

      def show
      end

      def new
        @message = Stay::Message.new
      end

      def create
        @message = Stay::Message.new(message_params)
        if @message.save
          redirect_to admin_message_path(@message), notice: 'Message was successfully created.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @message.update(message_params)
          redirect_to admin_message_path(@message), notice: 'Message was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @message.destroy
        redirect_to admin_messages_path, notice: 'Message was successfully destroyed.'
      end

      private

      def set_message
        @message = Stay::Message.find(params[:id])
      end

      def message_params
        params.require(:message).permit(:body, :sender_id, :receiver_id, :chat_id)
      end
    end
  end
end
