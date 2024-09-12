module Stay
  module Admin
    class ChatsController < ApplicationController
      before_action :set_chat, only: %i[show edit update destroy]

      def index
        @chats = Stay::Chat.all
      end

      def show
      end

      def new
        @chat = Stay::Chat.new
      end

      def create
        @chat = Stay::Chat.new(chat_params)
        if @chat.save
          redirect_to admin_chat_path(@chat), notice: 'Chat was successfully created.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @chat.update(chat_params)
          redirect_to admin_chat_path(@chat), notice: 'Chat was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @chat.destroy
        redirect_to admin_chats_path, notice: 'Chat was successfully destroyed.'
      end

      private

      def set_chat
        @chat = Stay::Chat.find(params[:id])
      end

      def chat_params
        params.require(:chat).permit(:sender_id, :receiver_id, :property_id)
      end
    end
  end
end
