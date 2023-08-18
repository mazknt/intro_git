class RelationshipsController < ApplicationController

    before_action :is_logged_in?, 

    def create
        @user = User.find(params[:id])
        current_user.follow(@user)
        #Hotwireによるページの部分更新
        respond_to do |format|
            format.html {redirect_to @user}
            format.turbo_stream
        end
    end

    def destroy
        @user = User.find(params[:id])
        current_user.unfollow(@user)
        #Hotwireによるページの部分更新
        respond_to do |format|
            format.html {redirect_to @user, status: :see_other}
            format.turbo_stream
        end
    end

    private

        def is_logged_in?
            unless logged_in?
                original_url = request.url if request.get?
                session[:original_url] = original_url
                redirect_to new_session_url
            end
        end
end
