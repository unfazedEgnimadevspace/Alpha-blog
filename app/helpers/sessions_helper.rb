module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
    end

    def current_user
       if (user_id = session[:user_id])
            @current_user ||=   User.find_by(id: user_id)
       elsif (user_id = cookies.encrypted[:user_id])
        user = User.find_by(id: user_id)
        if user && user.authenticated?(cookies[:remeber_token])
            log_in user
            @current_user = user
        end
       end
    end

    def logged_in?
        !current_user.nil?
    end
    def remeber(user)
        user.remeber
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remeber_token] = user.remeber_token
    end

    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remeber_token)
    end

    def log_out
        forget(current_user)
        session.delete(:user_id)
        current_user = nil
    end
    
end
