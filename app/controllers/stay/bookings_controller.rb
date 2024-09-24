module Stay
  class BookingsController < ActionController::Base
   def index
    render layout: 'stay/application'
   end

   def show 
    render layout: 'stay/application'
   end 
  end
end
