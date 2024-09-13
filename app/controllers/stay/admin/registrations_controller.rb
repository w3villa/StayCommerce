class Stay::Admin::RegistrationsController < Devise::RegistrationsController

  protected

  def after_sign_up_path_for(resource)
    assign_admin_role(resource)
    admin_users_path
  end

  def assign_admin_role(user)
    admin_role = Stay::Role.find_by(name: 'admin')
    if admin_role
      user.stay_roles << admin_role unless user.stay_roles.include?(admin_role)
    else
      Rails.logger.error "Admin role not found. Please ensure the 'admin' role exist."
    end
  end
end
