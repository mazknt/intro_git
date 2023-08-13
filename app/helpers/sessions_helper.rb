module SessionsHelper
    def reset_session
        session[:user_id] = nil
    end

    def log_in(user, remember_me) 
        remember(user) if remember_me == "1"
        session[:user_id] = user.id 
    end

    def logged_in?
        !current_user.nil?
    end

    def remember(user)
        user.remember
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def current_user
        #log_inしていたら適切なcurrent_userを返す
        if !session[:user_id].nil?
            user = User.find_by(id: session[:user_id])
            user
        elsif !cookies[:user_id].nil?
            user_id = cookies.encrypted[:user_id]
            user = User.find_by(id: user_id)
            if user && user.authenticated?(:remember, cookies[:remember_token])
                user 
            end
        end
    end

    def log_out(user)
        reset_session
        user.forget
        cookies.delete :remember_token
        cookies.delete :user_id
    end
end
