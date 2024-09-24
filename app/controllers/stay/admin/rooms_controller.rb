module Stay
  module Admin
    class RoomsController < Stay::Admin::BaseController

      before_action :set_property
      before_action :set_room, only: %i[show edit update destroy]

      def index
        @rooms = @property.rooms
      end

      def show
      end

      def new
        @room = @property.rooms.new
      end

      def create
        @room = @property.rooms.build(room_params)
        if @room.save
          redirect_to admin_property_rooms_path(@property), notice: 'Room was successfully created.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @room.update(room_params)
          redirect_to admin_property_room_path(@property), notice: 'Room was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @room.destroy
        redirect_to admin_property_rooms_path(@property), notice: 'Room was successfully destroyed.'
      end

      private

      def set_property
        @property = Stay::Property.find(params[:property_id])
      end

      def set_room
        @room = @property.rooms.find(params[:id])
      end

      def room_params
        params.require(:room).permit(:property_id, :max_guests, :price_per_night, :room_type_id, images: [])
      end
    end
  end
end
