module Stay
    module Api
      module V1
        class ContactUsController < ApplicationController
          before_action :set_contact, only: [:show, :update, :destroy]
  
          def index
            contacts = ContactUs.all
            render json: contacts
          end
  
          def show
            render json: @contact
          end
  
          def create
            contact = ContactUs.new(contact_params)
            if contact.save
              render json: {
                contact: contact, 
                message: "Contact us created successfully"
            }
            else
              render json: contact.errors, status: :unprocessable_entity
            end
          end
  
          def update
            if @contact.update(contact_params)
              render json: @contact
            else
              render json: @contact.errors, status: :unprocessable_entity
            end
          end
  
          def destroy
            @contact.destroy
            head :no_content
          end
  
          private
  
          def set_contact
            @contact = ContactUs.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            render json: { error: "Contact not found" }, status: :not_found
          end
  
          def contact_params
            params.require(:contact_us).permit(:name, :email, :mobile_number, :description)
          end
        end
      end
    end
  end
  