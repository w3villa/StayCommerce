# frozen_string_literal: true

class Stay::Users::PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session
  # skip_before_action :authenticate_devise_api_token!
  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    user = Stay::User.find_by(email: params[:user][:email])

    source = request.headers['Content-Type'] == 'application/json' ? 'json' : 'html'
    user.update(source: source)
    if user.present?
      user.send_reset_password_instructions
      user.source == 'json' ? render(json: { success: true, message: 'Password reset instructions have been sent to your email.' }) : redirect_to(new_session_path(resource_name))

    else
      user.source == 'json' ? render(json: { error: 'Email not found.' }) : redirect_to(new_session_path(resource_name))
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params[:user] || params)
      if self.resource.errors.empty?
        self.resource.source == 'json' ? render(json: { success: true, message: "Password has been successfully reset" }) : redirect_to(new_session_path(resource_name))
      else
        self.resource.source == 'json' ? render(json: { success: false, errors: self.resource.errors.full_messages }) : redirect_to(new_session_path(resource_name))
      end
  end

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
