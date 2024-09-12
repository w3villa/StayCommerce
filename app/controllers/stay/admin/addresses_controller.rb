module Stay
  module Admin
    class AddressesController < ApplicationController
      before_action :set_address, only: %i[show edit update destroy]

      # GET /Stay/admin/addresses
      # GET /Stay/admin/addresses.json
      def index
        @addresses = Stay::Address.all
      end

      # GET /Stay/admin/addresses/1
      # GET /Stay/admin/addresses/1.json
      def show
      end

      # GET /Stay/admin/addresses/new
      def new
        @address = Stay::Address.new
      end

      # GET /Stay/admin/addresses/1/edit
      def edit
      end

      # POST /Stay/admin/addresses
      # POST /Stay/admin/addresses.json
      def create
        @address = Stay::Address.new(address_params)

        respond_to do |format|
          if @address.save
            format.html { redirect_to [:admin, @address], notice: 'Address was successfully created.' }
            format.json { render :show, status: :created, location: @address }
          else
            format.html { render :new }
            format.json { render json: @address.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /Stay/admin/addresses/1
      # PATCH/PUT /Stay/admin/addresses/1.json
      def update
        respond_to do |format|
          if @address.update(address_params)
            format.html { redirect_to [:admin, @address], notice: 'Address was successfully updated.' }
            format.json { render :show, status: :ok, location: @address }
          else
            format.html { render :edit }
            format.json { render json: @address.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /Stay/admin/addresses/1
      # DELETE /Stay/admin/addresses/1.json
      def destroy
        @address.destroy
        respond_to do |format|
          format.html { redirect_to admin_addresses_url, notice: 'Address was successfully destroyed.' }
          format.json { head :no_content }
        end
      end

      private
        def set_address
          @address = Stay::Address.find(params[:id])
        end

        def address_params
          params.require(:address).permit(:address1, :address2, :city, :state, :country, :zipcode)
        end
    end
  end
end
