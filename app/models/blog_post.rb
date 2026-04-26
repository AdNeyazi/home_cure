class BlogPost < ApplicationRecord
  validates :title, :slug, :category, :author_name, :excerpt, :content, :published_at, presence: true
  validates :slug, uniqueness: true

  scope :published, -> { where(published: true).where("published_at <= ?", Time.current) }
  scope :recent_first, -> { order(published_at: :desc) }

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  def to_param
    slug
  end

  def preparation_tip_list
    preparation_tips.to_s.lines.map(&:strip).reject(&:blank?)
  end

  def faq_list
    faq_items.to_s.lines.map(&:strip).reject(&:blank?).map do |line|
      question, answer = line.split("||", 2).map { |part| part.to_s.strip }
      next if question.blank? || answer.blank?

      { question: question, answer: answer }
    end.compact
  end

  def disclaimer_text
    medical_disclaimer.presence || "This article is for education only and does not replace medical diagnosis or treatment advice."
  end

  private

  def generate_slug
    base = title.to_s.parameterize
    candidate = base
    suffix = 2

    while BlogPost.where.not(id: id).exists?(slug: candidate)
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end

    self.slug = candidate
  end
end
