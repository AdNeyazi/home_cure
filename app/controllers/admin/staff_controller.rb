module Admin
  class StaffController < BaseController
    before_action :require_lab_owner!
    before_action :set_member, only: :destroy
    before_action :set_invitation, only: %i[destroy_invitation]

    def index
      @members = current_lab.users.order(Arel.sql("CASE role WHEN 'lab_owner' THEN 0 ELSE 1 END"), :email)
      @invitations = current_lab.staff_invitations.pending.recent_first
      @invitation = current_lab.staff_invitations.new
    end

    def create
      @invitation = current_lab.staff_invitations.new(invitation_params)
      @invitation.invited_by = current_user
      @invitation.role = "lab_staff"

      if @invitation.save
        deliver_invitation(@invitation)
        redirect_to admin_staff_index_path, notice: invitation_success_notice(@invitation)
      else
        @members = current_lab.users.order(Arel.sql("CASE role WHEN 'lab_owner' THEN 0 ELSE 1 END"), :email)
        @invitations = current_lab.staff_invitations.pending.recent_first
        render :index, status: :unprocessable_entity
      end
    end

    def destroy
      if @member == current_user
        redirect_to admin_staff_index_path, alert: "You cannot remove yourself."
        return
      end

      if @member.lab_owner? && current_lab.users.lab_owners.count <= 1
        redirect_to admin_staff_index_path, alert: "You cannot remove the last lab owner."
        return
      end

      if @member.destroy
        redirect_to admin_staff_index_path, notice: "Team member removed."
      else
        redirect_to admin_staff_index_path, alert: @member.errors.full_messages.to_sentence
      end
    end

    def destroy_invitation
      @invitation.destroy!
      redirect_to admin_staff_index_path, notice: "Invitation cancelled."
    end

    private

    def current_lab
      current_user.lab
    end

    def require_lab_owner!
      return if current_user.lab_owner?

      redirect_to admin_dashboard_path, alert: "Only lab owners can manage staff."
    end

    def set_member
      @member = current_lab.users.find(params[:id])
    end

    def set_invitation
      @invitation = current_lab.staff_invitations.pending.find(params[:id])
    end

    def invitation_params
      params.require(:staff_invitation).permit(:email, :name)
    end

    def deliver_invitation(invitation)
      StaffInvitationMailer.invite(invitation).deliver_now
    rescue StandardError => e
      Rails.logger.warn("Staff invitation email failed: #{e.message}")
    end

    def invitation_success_notice(invitation)
      link = staff_invitation_url(invitation.token)
      "Invitation sent to #{invitation.email}. Share this link if needed: #{link}"
    end
  end
end
