class LabRegistrationsController < ApplicationController
  layout "auth"

  before_action :redirect_if_authenticated

  def new
    @lab = Lab.new
    @user = User.new
  end

  def create
    @lab = Lab.new(lab_params)
    @user = User.new(user_params)
    @user.role = "lab_owner"
    @user.lab = @lab

    lab_ok = @lab.valid?
    user_ok = @user.valid?
    unless lab_ok && user_ok
      render :new, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      @lab.save!
      @user.lab = @lab
      @user.save!
    end

    sign_in(@user)
    redirect_to admin_dashboard_path, notice: "Welcome! Your lab workspace is ready."
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  private

  def redirect_if_authenticated
    return unless user_signed_in?

    redirect_to(after_sign_in_path_for(current_user))
  end

  def lab_params
    params.require(:lab).permit(:name, :contact_email, :phone_number, :address)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
