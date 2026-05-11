module Admin
  class BillsController < BaseController
    require_dependency Rails.root.join("app/services/bill_pdf_builder").to_s

    before_action :set_bill, only: %i[show edit update destroy print pdf]

    def index
      @bills = Bill.with_patient.recent_first
    end

    def show; end

    def print; end

    def pdf
      send_data ::BillPdfBuilder.new(@bill).render,
                filename: "#{@bill.bill_number || "bill-#{@bill.id}"}.pdf",
                type: "application/pdf",
                disposition: "attachment"
    rescue LoadError
      redirect_to admin_bill_path(@bill), alert: "PDF dependency is missing. Run bundle install first."
    end

    def new
      @bill = Bill.new(bill_date: Date.current)
      @bill.bill_items.build
    end

    def create
      @bill = Bill.new(bill_params)
      if @bill.save
        redirect_to admin_bill_path(@bill), notice: "Bill generated successfully."
      else
        render_form_failure :new
      end
    end

    def edit
      @bill.bill_items.build if @bill.bill_items.empty?
    end

    def update
      if @bill.update(bill_params)
        redirect_to admin_bill_path(@bill), notice: "Bill updated successfully."
      else
        render_form_failure :edit
      end
    end

    def destroy
      @bill.destroy
      redirect_deleted admin_bills_path, "Bill"
    end

    private

    def set_bill
      @bill = Bill.find(params[:id])
    end

    def bill_params
      params.require(:bill).permit(
        :patient_id,
        :bill_date,
        :bill_number,
        :status,
        :amount_paid,
        bill_items_attributes: %i[id test_id test_package_id quantity unit_price discount_type discount_value status _destroy]
      )
    end
  end
end
