class Stay::RoomsController < Stay::BaseApiController
    before_action :set_property
    before_action :set_room, only: [:show]

    def index
        @rooms = @property.rooms
        render json: { rooms: @rooms }
    end

    def show
        render json: { room: @room }
    end
    
    private
    def set_property
        @property = Stay::Property.find(params[:property_id])
    end

    def set_room
        @room = @property.rooms.find(params[:id])
    end
end
