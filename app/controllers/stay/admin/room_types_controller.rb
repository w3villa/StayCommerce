module Stay
  class Admin::RoomTypesController < ApplicationController
    before_action :set_room_type, only: %i[show edit update destroy]

    # GET /admin/room_types
    def index
      @room_types = Stay::RoomType.all
    end

    # GET /admin/room_types/new
    def new
      @room_type = Stay::RoomType.new
    end

    # POST /admin/room_types
    def create
      @room_type = Stay::RoomType.new(room_type_params)
      if @room_type.save
        redirect_to admin_room_types_path, notice: 'Room type was successfully created.'
      else
        render :new
      end
    end

    # GET /admin/room_types/:id
    def show
    end

    # GET /admin/room_types/:id/edit
    def edit
    end

    # PATCH/PUT /admin/room_types/:id
    def update
      if @room_type.update(room_type_params)
        redirect_to admin_room_types_path, notice: 'Room type was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/room_types/:id
    def destroy
      @room_type.destroy
      redirect_to admin_room_types_path, notice: 'Room type was successfully deleted.'
    end

    private

    def set_room_type
      @room_type = Stay::RoomType.find(params[:id])
    end

    def room_type_params
      params.require(:room_type).permit(:name, :description)
    end
  end
end
