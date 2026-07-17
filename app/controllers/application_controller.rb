class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  layout :resolve_layout

  before_action :set_current_lab

  private

  def set_current_lab
    Current.lab = current_user&.lab if user_signed_in? && current_user.lab_member?
  end

  def resolve_layout
    return "application" unless devise_controller?
    return "admin" if devise_account_settings_action? && current_user&.lab_member?
    return "platform" if devise_account_settings_action? && current_user&.super_admin?

    "auth"
  end

  def devise_account_settings_action?
    controller_name == "registrations" && %w[edit update].include?(action_name)
  end

  def after_sign_in_path_for(resource)
    return platform_root_path if resource.respond_to?(:super_admin?) && resource.super_admin?
    return admin_dashboard_path if resource.respond_to?(:lab_member?) && resource.lab_member?

    super
  end

  def require_lab_member!
    authenticate_user!
    return if current_user&.lab_member? && current_user.lab&.active?

    if current_user&.super_admin?
      redirect_to platform_root_path, alert: "Use the platform console to manage labs."
      return
    end

    redirect_to root_path, alert: "You are not authorized to access this section."
  end

  def require_super_admin!
    authenticate_user!
    return if current_user&.super_admin?

    redirect_to root_path, alert: "You are not authorized to access this section."
  end

  # Kept for any remaining callers during the transition.
  def require_admin!
    require_lab_member!
  end
end
