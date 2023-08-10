class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      reset_session
      log_in(@user, params[:session][:remember_me])
      flash[:success] = "Log in successfully"
      redirect_to @user 
    else
      flash.now[:danger] = "failed to login"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out(current_user) unless current_user.nil?
    redirect_to root_path, status: :see_other
  end
end
