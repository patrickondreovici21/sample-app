class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]    
    before_action :correct_user, only: :destroy
    def create
        @micropost = current_user.microposts.build(micropost_params)
        puts @micropost.inspect
        if @micropost.save
            flash[:success] = "Micropost created!"
            redirect_to root_url
        else
            render 'static_pages/home', status: :unprocessable_entity
        end
    end

    def destroy
    end

    private
        def micropost_params
            params.require(:micropost).permit(:content)
        end


        def correct_user
            @micropost = current_user.microposts.find_by(id: params[:id])
            redirect_to root_url, status: :see_other if @micropost.nil?
        end
end
