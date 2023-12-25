class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:email_or_username]) || User.find_by(username: params[:email_or_username])
    if user && user.authenticate(params[:password]) # if user exists and password is correct
      session[:user_id] = user.id # set session to user's id
      redirect_to user, notice: "Welcome back, #{user.name}!" # redirect to user's profile page
    else
      flash.now[:alert] = "Invalid email/password combination!"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil # set session to nil
    redirect_to movies_url, status: :see_other, # redirect to home page
      notice: "You're now signed out!"
  end
end
