class Stay::Admin::SessionsController < Devise::SessionsController

  def create
    roles = Stay::User.find_by_email(params[:user][:email]).roles.pluck(:name)
    if roles.include? Stay::Role::ADMIN
      super
    else 
      flash[:error] = 'Access Denied, User must have admin role'
      redirect_to admin_login_path
    end 
  end 

	protected

	def respond_to_on_destroy
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_redirect(resource_name) }
    end
  end

  def after_sign_out_redirect(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:admin_login_path) ? context.admin_login_path : "/"
  end
end
