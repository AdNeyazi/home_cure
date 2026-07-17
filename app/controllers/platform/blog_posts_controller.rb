module Platform
  class BlogPostsController < BaseController
    before_action :set_blog_post, only: %i[edit update destroy]

    def index
      @blog_posts = BlogPost.recent_first
    end

    def new
      @blog_post = BlogPost.new(published_at: Time.current)
    end

    def create
      @blog_post = BlogPost.new(blog_post_params)
      if @blog_post.save
        redirect_created platform_blog_posts_path, "Blog post"
      else
        render_form_failure :new
      end
    end

    def edit; end

    def update
      if @blog_post.update(blog_post_params)
        redirect_updated platform_blog_posts_path, "Blog post"
      else
        render_form_failure :edit
      end
    end

    def destroy
      if @blog_post.destroy
        redirect_deleted platform_blog_posts_path, "Blog post"
      else
        redirect_with_errors platform_blog_posts_path, @blog_post
      end
    end

    private

    def set_blog_post
      @blog_post = BlogPost.find(params[:id])
    end

    def blog_post_params
      params.require(:blog_post).permit(
        :title, :slug, :category, :author_name, :reviewer_name, :reviewed_at, :cover_image_url,
        :excerpt, :content, :preparation_tips, :faq_items, :medical_disclaimer,
        :featured, :published, :published_at
      )
    end
  end
end
