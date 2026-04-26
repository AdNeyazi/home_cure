class AddEducationalFieldsToBlogPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :blog_posts, :reviewer_name, :string
    add_column :blog_posts, :reviewed_at, :datetime
    add_column :blog_posts, :preparation_tips, :text
    add_column :blog_posts, :faq_items, :text
    add_column :blog_posts, :medical_disclaimer, :text
  end
end
