module Admin
  class ReportsController < BaseController
    before_action :set_report, only: %i[edit update destroy]

    def index
      @reports = Report.with_admin_list_associations.recent_first
    end

    def new
      @report = Report.new(reported_on: Date.current)
    end

    def create
      @report = Report.new(report_params)
      if @report.save
        redirect_created admin_reports_path, "Report"
      else
        render_form_failure :new
      end
    end

    def edit; end

    def update
      if @report.update(report_params)
        redirect_updated admin_reports_path, "Report"
      else
        render_form_failure :edit
      end
    end

    def destroy
      @report.destroy
      redirect_deleted admin_reports_path, "Report"
    end

    private

    def set_report
      @report = Report.find(params[:id])
    end

    def report_params
      params.require(:report).permit(:patient_id, :doctor_id, :test_id, :reported_on, :file_path, :notes)
    end

  end
end
