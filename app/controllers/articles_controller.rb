class ArticlesController < ApplicationController
    def index
        @articles = Article.all
    end
    def show
        @article = Article.find_by(id: params[:id])
    end
    def new
        @article = Article.new
    end
     def create
        @article = Article.new(article_params)
        if @article.save
            flash[:success] = "Article was created successfully"
            redirect_to @article
        else
            render 'new'
        end
        
        
     end

     private
        def article_params
            params.require(:article).permit(:title, :description)
        end
end