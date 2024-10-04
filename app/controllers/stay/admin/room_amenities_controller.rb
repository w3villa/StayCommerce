module Stay
  class Admin::RoomAmenitiesController < Stay::Admin::BaseController
    before_action :set_property_and_room, only: [:index, :destroy, :new, :create]
    before_action :set_room_amenity, only: [:destroy]

    def index 
     @room_amenities =  @room.room_amenities
    end 
    
    def new
      @room_amenity = Stay::RoomAmenity.new
    end

    def create
      @room_amenity = Stay::RoomAmenity.new(room_amenity_params.merge(stay_room_id: params[:room_id]))
      if @room_amenity.save
        redirect_to admin_property_room_room_amenities_path(@property, @room), notice: 'Room Amenity was successfully added.'
      else
        render :new
      end
    end
  
    def destroy
       @room_amenity.destroy
       redirect_to admin_property_room_room_amenities_path, notice: 'Room Amenity was successfully destroyed.'
    end

    private

    def set_property_and_room
      @property = Stay::Property.find(params[:property_id]) if params[:property_id]
      @room = Stay::Room.find(params[:room_id]) if params[:room_id]
    end

    def set_room_amenity
      @room_amenity = @room.room_amenities.find(params[:id])
    end

    def room_amenity_params
      params.require(:room_amenity).permit(:stay_amenity_id, :description, :position, :active, :extra_charge)
    end
  end
end
