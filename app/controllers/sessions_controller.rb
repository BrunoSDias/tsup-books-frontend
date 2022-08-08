class SessionsController < ApplicationController
  skip_before_action :authenticate

  def signin
    @user = User.new
  end

  def signup
    @user = User.new
  end

  def signout
    cookies[:user_auth] = nil
    redirect_to sessions_signin_path
  end

  def create
    @user = User.new(session_params)
    if @user.save
      cookies[:user_auth] = @user.auth_token
      redirect_to books_url
      return
    end
    render :signup, status: 403
  end

  def login
    @user = User.authenticate(email: session_params[:email], password: session_params[:password])
    if @user.id
      cookies[:user_auth] = @user.auth_token
      redirect_to books_url
      return
    end
    render :signin, status: 403
  end

  private

  def session_params
    params.require(:session).permit(:name, :email, :password, :password_confirmation).to_h
  end
end
