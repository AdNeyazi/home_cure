class AmountInWords
  UNITS = %w[zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen].freeze
  TENS = %w[zero ten twenty thirty forty fifty sixty seventy eighty ninety].freeze
  SCALES = [
    [ 1_000_000_000, "billion" ],
    [ 1_000_000, "million" ],
    [ 1_000, "thousand" ],
    [ 100, "hundred" ]
  ].freeze

  def initialize(amount)
    @amount = amount
  end

  def to_words
    rupees = amount.to_d.floor
    return "Zero rupees only" if rupees.zero?

    "#{number_to_words(rupees)} rupees only"
  end

  private

  attr_reader :amount

  def number_to_words(number)
    return UNITS[number] if number < 20
    return "#{TENS[number / 10]} #{UNITS[number % 10]}".strip if number < 100

    SCALES.each do |value, label|
      next unless number >= value

      quotient = number / value
      remainder = number % value
      prefix = "#{number_to_words(quotient)} #{label}"
      return "#{prefix} #{number_to_words(remainder)}".strip if remainder.positive?

      return prefix
    end

    number.to_s
  end
end
