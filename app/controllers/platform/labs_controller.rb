module Platform
  class LabsController < BaseController
    before_action :set_lab, only: %i[show update]

    def index
      @labs = Lab.recent_first.includes(:users)
    end

    def show
      @owners = @lab.users.where(role: "lab_owner")
      @staff_count = @lab.users.where(role: "lab_staff").count
      @patients_count = @lab.patients.count
      @bills_count = @lab.bills.count
    end

    def update
      if @lab.update(lab_params)
        redirect_to platform_lab_path(@lab), notice: "Lab updated."
      else
        redirect_to platform_lab_path(@lab), alert: @lab.errors.full_messages.to_sentence
      end
    end

    private

    def set_lab
      @lab = Lab.find(params[:id])
    end

    def lab_params
      params.require(:lab).permit(:status)
    end
  end
end
