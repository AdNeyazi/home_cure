class Patient < ApplicationRecord
  include TenantScoped

  belongs_to :doctor, optional: true

  has_many :bills, dependent: :restrict_with_error
  has_many :reports, dependent: :restrict_with_error

  validates :full_name, presence: true

  scope :recent_first, -> { order(created_at: :desc) }
  scope :with_admin_list_associations, -> { includes(:doctor, bills: { bill_items: :test }) }
  scope :with_dashboard_associations, -> { includes(:doctor, :reports, bills: { bill_items: :test }) }
  scope :search, ->(query) { search_by_fields(query, :full_name, :phone_number, :email) }

  scope :search_directory, lambda { |query|
    term = query.to_s.strip
    return all if term.blank?

    id_match = term.match(/\A(?:PAT)?0*(\d+)\z/i)
    text_scope = search_by_fields(term, :full_name, :phone_number, :email)
    return text_scope unless id_match

    where(id: id_match[1].to_i).or(text_scope)
  }

  def primary_bill
    bills.order(:created_at).first
  end

  def selected_tests
    return [] unless primary_bill

    primary_bill.bill_items.includes(:test).map(&:test).compact
  end

  def selected_packages
    return [] unless primary_bill

    primary_bill.bill_items.includes(:test_package).filter_map(&:test_package).uniq
  end

  def selected_add_on_tests
    return [] unless primary_bill

    primary_bill.bill_items.includes(:test).select(&:add_on?).map(&:test).compact
  end

  def selected_test_names
    selected_tests.map(&:name).join(", ")
  end

  def selected_tests_total
    primary_bill&.total_amount.to_d
  end
end
