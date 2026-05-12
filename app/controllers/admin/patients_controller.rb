module Admin
  class PatientsController < BaseController
    before_action :set_patient, only: %i[show edit update destroy]
    before_action :load_tests, only: %i[new create edit update]
    before_action :load_test_packages, only: %i[new create edit update]
    before_action :load_doctors, only: %i[new create edit update]

    def index
      @patients = Patient.with_admin_list_associations.recent_first
    end

    def show; end

    def new
      @patient = Patient.new
    end

    def create
      @patient = Patient.new
      if save_patient_with_tests
        redirect_created admin_patients_path, "Patient"
      else
        render_form_failure :new
      end
    end

    def edit; end

    def update
      if save_patient_with_tests
        redirect_updated admin_patients_path, "Patient"
      else
        render_form_failure :edit
      end
    end

    def destroy
      if @patient.destroy
        redirect_deleted admin_patients_path, "Patient"
      else
        redirect_with_errors admin_patients_path, @patient
      end
    end

    private

    def set_patient
      @patient = Patient.find(params[:id])
    end

    def patient_params
      params.require(:patient).permit(:full_name, :age, :date_of_birth, :gender, :phone_number, :email, :address, :doctor_id)
    end

    def selected_test_ids
      params.fetch(:patient, {}).fetch(:test_ids, [])
    end

    def selected_package_ids
      params.fetch(:patient, {}).fetch(:test_package_ids, [])
    end

    def save_patient_with_tests
      Patients::SaveWithTests.new(
        @patient,
        attributes: patient_params,
        test_ids: selected_test_ids,
        package_ids: selected_package_ids
      ).call
    end

    def load_tests
      @tests = Test.alphabetical
    end

    def load_test_packages
      @test_packages = TestPackage.includes(:tests).alphabetical
    end

    def load_doctors
      @doctors = Doctor.alphabetical
    end
  end
end
