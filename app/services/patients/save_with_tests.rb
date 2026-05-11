module Patients
  class SaveWithTests
    require "set"

    def initialize(patient, attributes:, test_ids:, package_ids: [])
      @patient = patient
      @attributes = attributes
      @test_ids = test_ids
      @package_ids = package_ids
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

    attr_reader :patient, :attributes, :test_ids, :package_ids

    def sync_tests!
      packages = TestPackage.includes(:tests).where(id: normalized_package_ids)
      add_on_tests = Test.where(id: normalized_test_ids)
      bill = patient.primary_bill || patient.bills.build(bill_date: Date.current, status: "pending")

      desired_items = []
      seen_test_ids = Set.new

      packages.each do |package|
        package_price_applied = false

        package.tests.each do |test|
          next if seen_test_ids.include?(test.id)

          package_unit_price =
            if package.price.to_d.positive? && !package_price_applied
              package.price
            elsif package.price.to_d.positive?
              0
            else
              test.price
            end

          desired_items << { test: test, test_package: package, unit_price: package_unit_price }
          package_price_applied = true
          seen_test_ids << test.id
        end
      end

      add_on_tests.each do |test|
        next if seen_test_ids.include?(test.id)

        desired_items << { test: test, test_package: nil, unit_price: test.price }
        seen_test_ids << test.id
      end

      sync_bill_items!(bill, desired_items)
      bill.save!
    end

    def sync_bill_items!(bill, desired_items)
      desired_keys = desired_items.map { |item| [ item[:test].id, item[:test_package]&.id ] }

      bill.bill_items.each do |item|
        item.mark_for_destruction unless desired_keys.include?([ item.test_id, item.test_package_id ])
      end

      desired_items.each do |desired|
        existing = bill.bill_items.detect do |item|
          item.test_id == desired[:test].id && item.test_package_id == desired[:test_package]&.id
        end

        if existing
          existing.assign_attributes(test: desired[:test], test_package: desired[:test_package])
        else
          bill.bill_items.build(
            test: desired[:test],
            test_package: desired[:test_package],
            quantity: 1,
            unit_price: desired[:unit_price]
          )
        end
      end
    end

    def normalized_test_ids
      Array(test_ids).reject(&:blank?).map(&:to_i)
    end

    def normalized_package_ids
      Array(package_ids).reject(&:blank?).map(&:to_i)
    end
  end
end
