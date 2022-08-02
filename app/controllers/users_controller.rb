class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update]
  def index
    @users = User.paginate(page: params[:page], per_page: 2)
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 2)
  end


  def new
    @user = User.new
  end
  def create
    @user =User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to alpha blog #{ @user.username }, you have successfully signed up"
      log_in @user
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  def edit
    
  end
  def update
    
    if @user.update(user_params)
      flash[:success] = "Your profile  was edited successfully"
      redirect_to user_path(@user)
    else
      render 'edit'
    end

  end


  private

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end
end
