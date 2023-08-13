class ActivateAccountsController < ApplicationController

    def edit
        @user = User.find_by(email: params[:email])
        if @user && !@user.activated? &&@user.authenticated?(:activation, params[:id])
            @user.update_attribute(:activated, true)
            reset_session
            log_in(@user, "0")
            flash[:success] = "Your account was successfully activated"
            redirect_to @user
        else
            flash[:danger] = "invalid email"
            redirect_to root_path
        end
    end
end
