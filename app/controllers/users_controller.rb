class UsersController < ApplicationController
    before_action :is_logged_in?, only: [:edit, :update, :index, :destroy, :following, :followers]
    before_action :correct_user?, only: [:edit, :update]
    before_action :is_admin?, only: [:destroy]
    

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            flash[:success] = "check your email to activate your account"
            UsersMailer.activate_account(@user).deliver_now
            redirect_to root_path
        else
            render "new", states: :unprocessable_entity
        end
    end

    def show
        @user = User.find(params[:id])
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            flash[:success] = "User updated successfully"
            redirect_to root_path, status: :see_other
        else
            flash[:danger] = "User cannot updated"
            redirect_to edit_user_path(@user), status: :see_other
        end
    end

    def index
        @users = User.page(params[:page]).per(30)
    end

    def destroy
        user = User.find(params[:id])
        user.destroy
        flash[:success] = "User deleted successfully"
        redirect_to users_path, status: :see_other
    end

    def following
        @title =  "following"
        @user = User.find(params[:id])
        @users = @user.following.page(params[:page]).per[30]
        render "show_follow", status: :unprocessable_entity
    end

    def followers
        @title =  "followers"
        @user = User.find(params[:id])
        @users = @user.follower.page(params[:page]).per[30]
        render "show_follow", status: :unprocessable_entity
    end

    private
        def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end

        def is_logged_in?
            unless logged_in?
                original_url = request.url if request.get?
                session[:original_url] = original_url
                redirect_to new_session_url
            end
        end

        def correct_user?
            @user = User.find(params[:id])
            if @user != current_user
                flash[:danger] = "unauthorized access"
                redirect_to root_url
            end
        end

        def is_admin?
            unless current_user.admin?
                flash[:danger] = "unauthorized access"
                redirect_to users_url
            end
        end
end
