class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        user = User.new(user_params)
        if user.save
            flash[:success] = "User created successfully"
            redirecr_to root_path
        else
            flash.now[:danger] = "User not created successfully"
            render "new", states: :unprocessable_entity
        end
    end

    private
        def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirm)
        end
end
