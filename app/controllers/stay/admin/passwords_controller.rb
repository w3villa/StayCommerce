class Stay::Admin::PasswordsController < Devise::PasswordsController
  
  # GET /admin/password/new
  # def new
  #   super
  # end

  # POST /admin/password
  # def create
  #   super
  # end

  # GET /admin/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /admin/password
  # def update
  #   super
  # end

  protected

  def after_resetting_password_path_for(resource)
    admin_login_path
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    admin_login_path
  end
end
