class ContactInquiriesController < ApplicationController
  def new
    @contact_inquiry = ContactInquiry.new
  end

  def create
    @contact_inquiry = ContactInquiry.new(contact_inquiry_params)
    if @contact_inquiry.save
      redirect_to new_contact_inquiry_path, notice: "Thanks for contacting us. We will reach out soon."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_inquiry_params
    params.require(:contact_inquiry).permit(:full_name, :email, :phone_number, :subject, :message)
  end
end
