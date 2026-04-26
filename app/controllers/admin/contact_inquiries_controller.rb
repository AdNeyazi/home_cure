module Admin
  class ContactInquiriesController < BaseController
    before_action :set_contact_inquiry, only: %i[show destroy]

    def index
      @contact_inquiries = ContactInquiry.recent_first
    end

    def show; end

    def destroy
      if @contact_inquiry.destroy
        redirect_deleted admin_contact_inquiries_path, "Inquiry"
      else
        redirect_with_errors admin_contact_inquiries_path, @contact_inquiry
      end
    end

    private

    def set_contact_inquiry
      @contact_inquiry = ContactInquiry.find(params[:id])
    end
  end
end
