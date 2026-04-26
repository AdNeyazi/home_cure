class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def after_sign_in_path_for(resource)
    return admin_dashboard_path if resource.respond_to?(:admin?) && resource.admin?

    super
  end

  def require_admin!
    authenticate_user!
    return if current_user&.admin?

    redirect_to root_path, alert: "You are not authorized to access this section."
  end
end
