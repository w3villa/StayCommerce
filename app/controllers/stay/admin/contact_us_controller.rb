module Stay
    module Admin
      class ContactUsController < Stay::Admin::BaseController
        before_action :set_contact_us, only: %i[show destroy]
  
        def index
          @contact_us = Stay::ContactUs.page(params[:page])
        end
  
        def show
        end
  
        def destroy
          if @contact_us.destroy
            redirect_to admin_contact_us_path, notice: "Contact deleted successfully."
          else
            redirect_to admin_contact_us_path, alert: "Failed to delete contact."
          end
        end
  
        private
  
        def set_contact_us
          @contact_us = Stay::ContactUs.find(params[:id])
        end
      end
    end
  end
  