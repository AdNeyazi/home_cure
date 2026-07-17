module TenantScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :lab

    before_validation :assign_lab_from_current, on: :create

    default_scope -> {
      if Current.lab
        where(lab_id: Current.lab.id)
      else
        all
      end
    }
  end

  private

  def assign_lab_from_current
    self.lab ||= Current.lab if Current.lab
  end
end
