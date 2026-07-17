class StaffInvitationMailer < ApplicationMailer
  default from: "HomeCure <noreply@homecurelab.com>"

  def invite(invitation)
    @invitation = invitation
    @lab = invitation.lab
    @accept_url = staff_invitation_url(invitation.token)

    mail(
      to: invitation.email,
      subject: "You're invited to join #{@lab.name} on HomeCure"
    )
  end
end
