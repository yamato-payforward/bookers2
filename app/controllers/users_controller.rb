class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destory]

  def index
    @users = User.all
    @book = Book.new
  end
  
  def show
    @book = Book.new
  end

  def edit
    redirect_to users_path unless @user == current_user
  end

  def update
    if @user.update(user_params)
      redirect_to user_path , notice: 'Your information was successfully updated.'
    else 
      flash[:alert] = @user.errors.full_messages
      render "edit"
    end
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:name, :avatar, :bio)
  end

end
