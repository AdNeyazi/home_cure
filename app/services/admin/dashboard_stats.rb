module Admin
  class DashboardStats
    def total_patients
      Patient.count
    end

    def pending_bills_count
      Bill.pending.count
    end

    def processing_reports_count
      Report.processing.count
    end

    def revenue_total
      paid_bills.sum(:total_amount)
    end

    def revenue_completed_count
      paid_bills.count
    end

    private

    def paid_bills
      Bill.paid
    end
  end
end
