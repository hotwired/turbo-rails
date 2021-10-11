class ArticlesController < ApplicationController
  def new
    @article = Article.new
  end

  def show
    @article = Article.find params[:id]
  end

  def create
    @article = Article.create! article_params

    redirect_to article_url(@article.id)
  end

  private

  def article_params
    params.fetch(:article, {}).permit(:body).with_defaults(body: "Default Article body")
  end
end
