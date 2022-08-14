class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update]
  before_action :require_user , only: [ :edit, :update]
  before_action :require_same_user, only: [:edit, :update]
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
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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
    def require_same_user
      if current_user != @user
        flash[:danger] = "Unauthorized access"
        redirect_to user_path(@user)
      end
    end
end
