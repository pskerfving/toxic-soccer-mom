# coding: UTF-8

class EmailVerificationsController < ApplicationController

  def verify_email
    user = User.find_by_email_verification_token(params[:id])
    user.email_verified = true
    user.save!
    session[:user_id] = user.id
    redirect_to(:root, :notice => "Vi gillar din mailadress!")
  end

end
