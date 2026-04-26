module ReferralReports
  class MonthlyQuery
    def initialize(month:, year:, doctor_id: nil)
      @month = month
      @year = year
      @doctor_id = doctor_id
    end

    def rows
      bills.map { |bill| row_for(bill) }
    rescue Date::Error
      []
    end

    private

    attr_reader :month, :year, :doctor_id

    def bills
      scope = Bill
              .joins(:patient)
              .includes({ bill_items: :test }, { patient: :doctor })
              .where(bill_date: date_range)
              .where.not(patients: { doctor_id: nil })
              .order(:bill_date, :id)

      return scope if doctor_id.blank?

      scope.where(patients: { doctor_id: doctor_id })
    end

    def date_range
      start_date = Date.new(year, month, 1)
      start_date..start_date.end_of_month
    end

    def row_for(bill)
      patient = bill.patient
      doctor = patient.doctor

      {
        patient_name: patient.full_name,
        phone: patient.phone_number.presence || "-",
        doctor_name: doctor&.full_name || "-",
        tests_done: test_names_for(bill),
        bill_amount: bill.gross_amount.to_s("F"),
        discount: bill.total_discount.to_s("F"),
        amount_paid: amount_paid_for(bill).to_s("F"),
        amount_due: amount_due_for(bill).to_s("F"),
        bill_status: bill.status.to_s.titleize
      }
    end

    def test_names_for(bill)
      bill.bill_items.map { |item| item.test&.name }.compact.uniq.join(", ")
    end

    def amount_paid_for(bill)
      return bill.total_amount.to_d if bill.paid?

      0.to_d
    end

    def amount_due_for(bill)
      return bill.total_amount.to_d if bill.pending?

      0.to_d
    end
  end
end
