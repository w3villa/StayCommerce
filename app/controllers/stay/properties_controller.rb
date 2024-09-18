module Stay
  class PropertiesController < ActionController::Base
   def index
    @properties = Stay::Property.all
    render layout: 'stay/application'
   end

   def show 
    @property = Property.find(params[:id])
    @average_rating = @property.average_rating
    @reviews_count = @property.reviews_count
    render layout: 'stay/application'
   end 
  end
end
