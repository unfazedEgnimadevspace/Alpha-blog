class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      if params[:session][:remember_me] == '1'
        remeber user
      else
        forget(user)
      end
      flash[:success] = "Welcome back!"
      redirect_to user
    else  
      flash[:danger] = "Invalid username and password"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to users_path
  end
end
