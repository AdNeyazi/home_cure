module Patients
  class SaveWithTests
    def initialize(patient, attributes:, test_ids:)
      @patient = patient
      @attributes = attributes
      @test_ids = test_ids
    end

    def call
      patient.assign_attributes(attributes)

      ActiveRecord::Base.transaction do
        patient.save!
        sync_tests!
      end

      true
    rescue ActiveRecord::RecordInvalid
      false
    end

    private

    attr_reader :patient, :attributes, :test_ids

    def sync_tests!
      tests = Test.where(id: normalized_test_ids)
      bill = patient.primary_bill || patient.bills.build(bill_date: Date.current, status: "pending")

      bill.bill_items.destroy_all
      tests.each do |test|
        bill.bill_items.build(test: test, quantity: 1, unit_price: test.price)
      end

      bill.save!
    end

    def normalized_test_ids
      Array(test_ids).reject(&:blank?).map(&:to_i)
    end
  end
end
