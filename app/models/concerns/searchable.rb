module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def search_by_fields(query, *fields)
      return all if query.blank?

      safe_query = sanitize_sql_like(query.to_s.strip)
      conditions = fields.map { |field| "#{field} ILIKE :q" }.join(" OR ")

      where(conditions, q: "%#{safe_query}%")
    end
  end
end
