class CategoriesController < ApplicationController
    before_action :require_admin, except:[:show, :index]
    def new
        @category = Category.new
    end


    def index
        @categories = Category.paginate(page: params[:page], per_page: 3)
    end

    def show
        @category = Category.find(params[:id])
        @articles = @category.articles.paginate(page: params[:page], per_page: 2)
    end
    def edit
        @category = Category.find(params[:id])
    end

    def update
        @category = Category.find(params[:id])
        if @category.update(category_params)
            flash[:success] = "Category was successful updated"
            redirect_to @category
        else
            render 'edit'
        end
    end

    def create
        @category = Category.new(category_params)
        if @category.save
            flash[:success] = "New category category created successfully"
            redirect_to @category
        else
            render 'new'
        end
    end
   
    private
        def category_params
            params.require(:category).permit(:name)
        end
        def require_admin
            if !(logged_in? && current_user.admin?)
                flash[:danger] = "Only admins can perform that action"
                redirect_to categories_path
            end            
        end

end