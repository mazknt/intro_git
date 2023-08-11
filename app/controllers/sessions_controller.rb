class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      original_url = session[:original_url] unless session[:original_url].nil?
      reset_session
      log_in(@user, params[:session][:remember_me])
      flash[:success] = "Log in successfully"
      if !original_url.nil?
        redirect_to original_url
      else
        redirect_to @user 
      end
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
