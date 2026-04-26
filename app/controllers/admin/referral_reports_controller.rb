module Admin
  class ReferralReportsController < BaseController
    def index
      load_filters
      @rows = referral_report_rows
    end

    def export
      load_filters
      rows = referral_report_rows

      send_data ReferralReports::CsvExporter.new(rows).to_csv,
                filename: "doctor-referral-business-#{@selected_year}-#{format('%02d', @selected_month)}.csv",
                type: "text/csv; charset=utf-8"
    end

    private

    def load_filters
      today = Date.current
      @selected_month = safe_integer(params[:month], today.month).clamp(1, 12)
      @selected_year = safe_integer(params[:year], today.year)
      @selected_doctor_id = safe_integer(params[:doctor_id].presence, nil)
      @doctors = Doctor.alphabetical
    end

    def referral_report_rows
      ReferralReports::MonthlyQuery.new(
        month: @selected_month,
        year: @selected_year,
        doctor_id: @selected_doctor_id
      ).rows
    end

    def safe_integer(value, fallback)
      Integer(value)
    rescue ArgumentError, TypeError
      fallback
    end
  end
end
