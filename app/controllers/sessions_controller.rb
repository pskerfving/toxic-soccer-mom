# coding: UTF-8

class SessionsController < ApplicationController

  def new
    @identity = env['omniauth.identity']
  end

  def create
    # raise env['omniauth.auth'].to_yaml

    auth_hash = request.env['omniauth.auth']

    # Try to find an authorization
    @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    if @authorization
      # Set the user from the authorization we found
      session[:user_id] = @authorization.user.id
      redirect_to :root, :notice => "Du är inloggad. Lycka till med tippningen!"
    else
      # No authorization found. Create a new user and an authorization form the info provided
      puts "---------------- HITTADE INGEN PERSON"
      user = User.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
      puts user.name
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      puts "---------------- SKAPAT AUTH"      
      user.admin = false
      user.cleared = false
      user.points = 0
      puts "---------------- SPARAR"
      user.save
      session[:user_id] = user.id
      redirect_to :root, :notice => "Nu är du registrerad och inloggad."
      if user.email != nil
        UserMailer.welcome(user).deliver
      end
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
