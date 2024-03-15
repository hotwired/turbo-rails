class ArticlesController < ApplicationController
  before_action :assert_param_method!, only: [:update, :destroy]

  def index
    @articles = Article.all
  end

  def edit
    @article = Article.find params[:id]
  end

  def update
    @article = Article.find params[:id]

    @article.update! article_params

    redirect_to articles_url
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new article_params

    if @article.save
      flash.notice = "Created!"

      redirect_to articles_url, redirect_params.to_h.to_options
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find params[:id]

    @article.destroy!

    redirect_to articles_url
  end

  def destroy_all
    Article.destroy_all
    redirect_to articles_url, status: :see_other
  end

  private

  def article_params
    params.require(:article).permit(:body)
  end

  def redirect_params
    params.permit(:alert, :notice, :status, :turbo_action, :turbo_frame, flash: {}).with_defaults(status: :found)
  end

  def assert_param_method!
    raise unless params[:_method].present?
  end
end
