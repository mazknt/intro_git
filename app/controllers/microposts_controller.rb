class MicropostsController < ApplicationController
    before_action :is_logged_in?
    before_action :correct_user? ,only: [:destroy]

    def create
        @micropost = current_user.microposts.build(micropost_params)
        #@micropost.image.attach(params[:micropost][:image])
        if @micropost.save
            flash[:success] = "Posted"
            redirect_to root_path
        else
            render "static_pages/home", status: :see_other
        end
    end

    def destroy
        @micropost = Micropost.find(params[:id])
        if @micropost
            @micropost.destroy
            redirect_to root_path, status: :see_other
        else
            flash[:danger] = "Failed"
            render "static_pages/home", status: :unprocessable_entity
        end
    end

    private
        def is_logged_in?
            unless logged_in?
                original_url = request.url if request.get?
                session[:original_url] = original_url
                redirect_to new_session_url, status: :see_other
            end
        end

        def micropost_params
            params.require(:micropost).permit(:content)
        end

        def correct_user?
            micropost = Micropost.find(params[:id])
            unless current_user == micropost.user
                flash[:danger] = "unauthenticated access"
                redirect_to root_path, status: :see_other
            end
        end
end
