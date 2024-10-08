class Stay::Api::V1::AmenityController < Stay::BaseApiController

  def index
    @amenities = Stay::Amenity.all
  end

end