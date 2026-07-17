class StaffInvitationsController < ApplicationController
  layout "auth"

  before_action :set_invitation
  before_action :ensure_pending_invitation
  before_action :redirect_if_authenticated

  def show
    @user = User.new(email: @invitation.email)
  end

  def create
    begin
      user = @invitation.accept!(
        password: user_params[:password],
        password_confirmation: user_params[:password_confirmation]
      )
      sign_in(user)
      redirect_to admin_dashboard_path, notice: "Welcome to #{user.lab.name}. Your staff account is ready."
    rescue ActiveRecord::RecordInvalid => e
      @user = e.record.is_a?(User) ? e.record : User.new(email: @invitation.email)
      @user.errors.add(:base, e.message) unless @user.errors.any?
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_invitation
    @invitation = StaffInvitation.find_by!(token: params[:token])
  end

  def ensure_pending_invitation
    return if @invitation.pending?

    redirect_to new_user_session_path, alert: invitation_unavailable_message
  end

  def invitation_unavailable_message
    if @invitation.accepted?
      "This invitation has already been accepted. Please sign in."
    else
      "This invitation has expired. Ask your lab owner to send a new one."
    end
  end

  def redirect_if_authenticated
    return unless user_signed_in?

    redirect_to after_sign_in_path_for(current_user), alert: "Sign out before accepting an invitation."
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
