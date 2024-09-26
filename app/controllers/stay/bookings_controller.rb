module Stay
  class BookingsController < ActionController::Base
    before_action :set_property, only: [:create]
   def new
    render layout: 'stay/application'
   end

   def create
    @booking = current_user.bookings.new(check_in_date: params[:check_in_date], check_out_date: params[:check_out_date])
    
    @booking.add_rooms_and_calculate(params[:selected_rooms], params, @property)

    if @booking.save
      redirect_to new_property_booking_payment_path(property_id: @property.id, booking_id: @booking.id)
    else
      redirect_to property_path(@property)
    end
   end
   private

   def permitted_booking_params(params)
    params.permit(:check_in_date, :check_out_date, :number_of_guests, :total)
  end
  def set_property   
    @property= Stay::Property.find(params["property_id"])
  end

  end
end
