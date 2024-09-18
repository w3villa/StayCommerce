module Stay
  class PropertiesController < ActionController::Base
   def index
    @properties = Stay::Property.all
    render layout: 'stay/application'
   end

   def show 
    @property = Property.find(params[:id])
    render layout: 'stay/application'
   end 
  end
end
