module Stay
  class Admin::CitiesController < Stay::Admin::BaseController
    before_action :set_state
    before_action :set_city, only: [:edit, :update, :destroy]

    def index
      @cities = @state.cities
      respond_to do |format|
      format.html
      format.json { render json: @cities }
    end

    end

    def new
      @city = @state.cities.new
    end

    def create
      @city = @state.cities.new(city_params)
      if @city.save
        redirect_to admin_state_cities_path(@state), notice: 'City was successfully created.'
      else
        flash.now[:alert] = @city.errors.full_messages.join(', ')
        render :new
      end
    end

    def edit
    end

    def update
      if @city.update(city_params)
        redirect_to admin_state_cities_path(@state), notice: 'City was successfully updated.'
      else
        flash.now[:alert] = @city.errors.full_messages.join(', ')
        render :edit
      end
    end

    def destroy
     if @city.destroy
        flash[:alert] = "City was successfully deleted."
        redirect_to admin_state_cities_path(@state)
      else
        flash[:alert] = @city.errors.full_messages.join(', ')
        redirect_to admin_state_cities_path(@state)
      end
    end

    private


    def set_state
      @state = Stay::State.find(params[:state_id])
    end

    def set_city
      @city = @state.cities.find(params[:id])
    end

    def city_params
      params.require(:city).permit(:name)
    end
  end
end
