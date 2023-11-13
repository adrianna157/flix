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
  end
end
