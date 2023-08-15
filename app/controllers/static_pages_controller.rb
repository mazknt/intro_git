class StaticPagesController < ApplicationController

    def home
        if logged_in?
            @micropost = current_user.microposts.build
            @feed_items = Micropost.where("user_id = ?", current_user.id).page(params[:page]).per(30)
        end
    end
end
