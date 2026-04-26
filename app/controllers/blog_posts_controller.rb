class BlogPostsController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @category = params[:category].to_s.strip

    posts = BlogPost.published.recent_first
    posts = posts.where(category: @category) if @category.present?
    if @query.present?
      posts = posts.where("title ILIKE :q OR excerpt ILIKE :q OR content ILIKE :q", q: "%#{@query}%")
    end

    @categories = BlogPost.published.distinct.order(:category).pluck(:category)
    @featured_post = posts.where(featured: true).first
    @posts = @featured_post.present? ? posts.where.not(id: @featured_post.id) : posts
  end

  def show
    @post = BlogPost.published.find_by!(slug: params[:id])
    @related_posts = BlogPost.published.where(category: @post.category).where.not(id: @post.id).recent_first.limit(3)
  end
end
