class ArticlesController < ApplicationController
    before_action :set_article, only: [ :show, :edit, :update, :destroy ]

    def index
        @articles = Article.paginate(page: params[:page], per_page: 2)
    end

    def show
    end


    def new
        @article = Article.new
    end
    def edit
    end

    def create
        @article = Article.new(article_params)
        @article.user = current_user
        if @article.save
            flash[:success] = "Article was created successfully"
            redirect_to @article
        else
            render 'new'
        end
    end

    def update

        if @article.update(article_params)
            flash[:success] ="Article updated sucessfully"
            redirect_to @article
        else
            render "edit"
        end
    end
    
    def destroy
        @article.destroy
        redirect_to articles_url
    end

     private
        def set_article
            @article = Article.find_by(id: params[:id])
        end
        def article_params
            params.require(:article).permit(:title, :description)
        end
end