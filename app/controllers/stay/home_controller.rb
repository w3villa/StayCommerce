module Stay
  class HomeController < ActionController::Base
   def index
    render layout: 'stay/application'
   end
  end
end
