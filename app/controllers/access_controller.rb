class AccessController < ApplicationController
  before_action :prevent_login_signup, only: [:signup, :login]
  # before_action :mandatory_login, only: [:home]
  def signup
    @user = User.new
  end

  def login
  end

  def home
  end

  def logout
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render :signup
    end
  end

  def attempt_login
    if params[:username].present? && params[:password].present?
      found_user = User.where(username: params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
        if authorized_user
          redirect_to home_path
        else 
          redirect_to login_path
        end
      else
        redirect_to signup_path
      end
    else
      redirect_to signup_path
    end 
  end

  def logout
    session[:user_id]= nil

    redirect_to login_path
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :password_digest)
  end
  def prevent_login_signup
    if session[:user_id]
      redirect_to home_path
    end
  end

  # def mandatory_login
    # if session[:user_id] == nil
      # redirect_to login_path
    # end
  # end
end
