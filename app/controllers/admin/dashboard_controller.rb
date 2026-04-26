module Admin
  class DashboardController < BaseController
    def index
      @q = params[:q].to_s.strip
      patients_scope = Patient.with_dashboard_associations
      patients_scope = patients_scope.search(@q) if @q.present?
      @patients = patients_scope.recent_first.limit(50)

      stats = DashboardStats.new
      @total_patients = stats.total_patients
      @pending_bills_count = stats.pending_bills_count
      @processing_count = stats.processing_reports_count
      @revenue_total = stats.revenue_total
      @revenue_completed_count = stats.revenue_completed_count
    end
  end
end
