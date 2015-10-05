# coding: UTF-8

class PasswordResetsController < ApplicationController
  def new
    @show_banner = false
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url, :notice => "Email skickat med instruktioner."
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Tiden har gått ut. Begär nya instruktioner!"
    else
      # If it is not provider = identity, the password cannot be reset.
      @auth = @user.authorizations.where(:provider => "identity").first
      if @auth
        @identity = Identity.find(@auth.uid)
        @identity.password = (params[:user][:password])
        @identity.password_confirmation = (params[:user][:password_confirmation])
        @identity.save
        redirect_to root_url, :notice => "Ditt lösenord är uppdaterat!"
      else
        render :edit
      end 
    end
  end
end
