module Stay
  class Admin::RoomAmenitiesController < Stay::Admin::BaseController
    before_action :set_property_and_room, only: [:index]

    private

    def set_property_and_room
      @property = Stay::Property.find(params[:property_id]) if params[:property_id]
      @room = Stay::Room.find(params[:room_id]) if params[:room_id]
    end
  end
end
