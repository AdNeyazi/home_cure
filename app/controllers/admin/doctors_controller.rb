module Admin
  class DoctorsController < BaseController
    before_action :set_doctor, only: %i[edit update destroy]

    def index
      @doctors = Doctor.recent_first
    end

    def new
      @doctor = Doctor.new
    end

    def create
      @doctor = Doctor.new(doctor_params)
      if @doctor.save
        redirect_created admin_doctors_path, "Doctor"
      else
        render_form_failure :new
      end
    end

    def edit; end

    def update
      if @doctor.update(doctor_params)
        redirect_updated admin_doctors_path, "Doctor"
      else
        render_form_failure :edit
      end
    end

    def destroy
      if @doctor.destroy
        redirect_deleted admin_doctors_path, "Doctor"
      else
        redirect_with_errors admin_doctors_path, @doctor
      end
    end

    private

    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    def doctor_params
      params.require(:doctor).permit(:full_name, :specialization, :phone_number, :email)
    end
  end
end
