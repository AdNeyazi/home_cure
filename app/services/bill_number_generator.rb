class BillNumberGenerator
  def initialize(scope = Bill, lab_id: nil)
    @scope = scope
    @lab_id = lab_id
  end

  def generate
    loop do
      candidate = "BILL-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.random_number(9999).to_s.rjust(4, '0')}"
      break candidate unless exists?(candidate)
    end
  end

  private

  attr_reader :scope, :lab_id

  def exists?(candidate)
    relation = scope
    relation = relation.where(lab_id: lab_id) if lab_id.present?
    relation.exists?(bill_number: candidate)
  end
end
