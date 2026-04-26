require "csv"

module ReferralReports
  class CsvExporter
    HEADERS = [
      "Patient Name",
      "Phone",
      "Doctor (Referred By)",
      "Tests Done",
      "Bill Amount",
      "Discount",
      "Amount Paid",
      "Amount Due",
      "Bill Status"
    ].freeze

    def initialize(rows)
      @rows = rows
    end

    def to_csv
      CSV.generate(headers: true) do |csv|
        csv << HEADERS
        rows.each { |row| csv << values_for(row) }
      end
    end

    private

    attr_reader :rows

    def values_for(row)
      [
        row[:patient_name],
        row[:phone],
        row[:doctor_name],
        row[:tests_done],
        row[:bill_amount],
        row[:discount],
        row[:amount_paid],
        row[:amount_due],
        row[:bill_status]
      ]
    end
  end
end
