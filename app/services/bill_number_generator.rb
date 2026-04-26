class BillNumberGenerator
  def initialize(scope = Bill)
    @scope = scope
  end

  def generate
    loop do
      candidate = "BILL-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.random_number(9999).to_s.rjust(4, '0')}"
      break candidate unless scope.exists?(bill_number: candidate)
    end
  end

  private

  attr_reader :scope
end
