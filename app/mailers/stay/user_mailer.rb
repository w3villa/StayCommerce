module Stay
  class UserMailer < ApplicationMailer
    def welcome_email(user)
      @user = user
      mail(to: @user.email, subject: "Welcome #{@user.full_name}")
    end

    def new_host_signup(user)
      @user = user
      mail(to: Stay::User.admin_emails, subject: "New Host Signup")
    end
  end
end
