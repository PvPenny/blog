class ComentController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_post
  before_action :set_comment, only:  [:update, :destroy]
  
  def index
    post = Post.find(params[:post_id])
    comments =post.coments.ordered.page(params[:page]).per(5).map{|comment| comment.show}
    render json: comments
  end

  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
  end
  
  def create
    @comment = Coments.create current_user, @post, comment_params
    if @comment.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end
  
  private
    def set_comment
      @comment = @post.coments.find(params[:id])
      current_user.coments.find(params[:id])
      if @comment.created_at < (DateTime.now - 15.minutes)
        @comment.errors.add(:created_at, 'Коментарий не может быть обновлен после 15 минут')
        render json:@comment.errors, status: :unprocessable_entity
      end
    end
    
    def set_post
      @post = Post.find(params[:post_id])
    end
  
    def comment_params
      params.require(:comment).permit(:text)
    end
end
