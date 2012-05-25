# coding: UTF-8

class SessionsController < ApplicationController
  def new
    @identity = @identity = env['omniauth.identity']
  end

  def create
    auth_hash = request.env['omniauth.auth']

    @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    if @authorization
      session[:user_id] = @authorization.user.id
      redirect_to :root, :notice => "Du är inloggad. Lycka till med tippningen!"
    else
      user = User.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      user.admin = false
      user.cleared = false
      user.points = 0
      user.save
      redirect_to :root, :notice => "Nu är du registrerad. Nästa steg är att logga in."
      UserMailer.welcome(user).deliver
    end
  end

  def failure
    render :text => "Beklagar, det gick bananas!"
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to :back
  end
end
