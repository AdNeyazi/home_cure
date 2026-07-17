class Report < ApplicationRecord
  include TenantScoped

  belongs_to :patient
  belongs_to :doctor, optional: true
  belongs_to :test, optional: true

  validates :reported_on, presence: true

  scope :recent_first, -> { order(reported_on: :desc) }
  scope :with_admin_list_associations, -> { includes(:patient, :doctor, :test) }
  scope :processing, -> { where("file_path IS NULL OR file_path = ''") }

  before_validation :set_reported_on

  private

  def set_reported_on
    self.reported_on ||= Date.current
  end
end
