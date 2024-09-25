class Stay::Admin::StatesController < Stay::Admin::BaseController
  before_action :set_country
  before_action :set_state, only: [:show, :edit, :update, :destroy]

  # GET /admin/countries/:country_id/states
  def index
    @states = @country.states
    respond_to do |format|
      format.html
      format.json { render json: @states }
    end
  end

  # GET /admin/countries/:country_id/states/:id
  def show
  end

  # GET /admin/countries/:country_id/states/new
  def new
    @state = @country.states.build
  end

  # POST /admin/countries/:country_id/states
  def create
    @state = @country.states.build(state_params)
    if @state.save
      redirect_to admin_country_states_path(@country), notice: 'State was successfully created.'
    else
      render :new
    end
  end

  # GET /admin/countries/:country_id/states/:id/edit
  def edit
  end

  # PATCH/PUT /admin/countries/:country_id/states/:id
  def update
    if @state.update(state_params)
      redirect_to admin_country_states_path(@country), notice: 'State was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/countries/:country_id/states/:id
  def destroy
    @state.destroy
    redirect_to admin_country_states_path(@country), notice: 'State was successfully deleted.'
  end

  private

  # Set the country based on country_id from the URL
  def set_country
    @country = Stay::Country.find(params[:country_id])
  end

  # Set the state for show, edit, update, and destroy actions
  def set_state
    @state = @country.states.find(params[:id])
  end

  # Strong parameters to allow specific attributes for states
  def state_params
    params.require(:state).permit(:name, :abbr, :country_id)
  end
end
