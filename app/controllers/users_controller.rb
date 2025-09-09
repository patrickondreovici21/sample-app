class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @pagy, @users = pagy(User.order(:name))
  end

  def new
    @user = User.new
  end


  # users_controller.rb
  def search
    @query = params[:query].to_s.strip
    @results = @query.blank? ? [] : User.search_by_name(@query).records.limit(5)

    respond_to do |format|
      format.json { render json: @results.map { |u| { id: u.id, name: u.name } } }
    end
  end

  
  
  
  
  
  

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:alert] = "User not found"
      redirect_to root_path
    else
      @pagy, @microposts = pagy(@user.microposts.includes(image_attachment: :blob), overflow: :last_page)
    end
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end


  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      IndexUserJob.perform_later(@user.id)
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end


  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end


  def following
    @title = "Following"
    @user = User.find(params[:id])
    @pagy, @users = pagy(@user.following)
    render 'show_follow', status: :unprocessable_entity
  end


  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @pagy, @users = pagy(@user.followers)
    render 'show_follow', status: :unprocessable_entity
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
      
    def correct_user
      @user = User.find_by(id: params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end

end
