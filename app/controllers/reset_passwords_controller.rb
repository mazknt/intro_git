class ResetPasswordsController < ApplicationController

    def new
    end

    def create
        @user = User.find_by(email: params[:reset_password][:email])
        if @user
            @user.reset_password
            #user.update_attribute(:reset_digest, user.reset_digest)
            UsersMailer.reset_password(@user).deliver_now
            flash[:success] = "send a email"
            redirect_to root_path
        else
            flash.now[:danger] = "invalid email address"
            render "new", status: :unprocessable_entity
        end
    end

    def edit
        @user = User.find_by(email: params[:email])
        unless @user && @user.authenticated?(:reset, params[:id])
            flash[:danger] = "invalid email address"
            redirect_to root_path, status: :see_other
        end
    end

    def update
        @user = User.find_by(email: params[:email])
        if @user && @user.authenticated?(:reset, params[:id])
            if params[:user][:password].empty?                  # （3）への対応
                @user.errors.add(:password, "can't be empty")
                render 'edit', status: :unprocessable_entity
            elsif @user.update(user_params)                     # （4）への対応
                reset_session
                log_in @user, "0"
                flash[:success] = "Password has been reset."
                redirect_to @user
            else
                render 'edit', status: :unprocessable_entity      # （2）への対応
            end
        end
    end

    private
        def user_params
            params.require(:user).permit(:password, :password_confirmation)
        end
end
