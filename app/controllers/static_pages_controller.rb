class StaticPagesController < ApplicationController

    def home
        if logged_in?
            @micropost = current_user.microposts.build
            following_ids = "SELECT following_id FROM relationship WHERE follower_id = :user_id"
            @feed_items = Micropost.where("user_id IN #{following_ids} OR user_id = :user_id", user_id: current_user.id).page(params[:page]).per(30).includes(:user, image_attachment: :blob)
        end
    end
end
