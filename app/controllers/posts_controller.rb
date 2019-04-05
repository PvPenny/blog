class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:update, :destroy]
  # GET /posts
  def index
    posts = Post.published.ordered.page(params[:page]).per(5).map{|post| post.show}
    render json: posts
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
    render json: @post.show
  end

  # POST /posts
  def create
    @post = Post.create(current_user, post_params)
    
    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if Post.update(@post,post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = current_user.posts.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:text, :published, tags: [])
    end
    
    
  
end
