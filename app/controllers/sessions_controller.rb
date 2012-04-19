class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']

    @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    if @authorization
#      render :text => "Welcome back #{@authorization.user.name}! You have already signed up."
      session[:user_id] = @authorization.user.id
      redirect_to :root, :notice => "Inloggad. Lycka till med tippningen!"
    else
      user = User.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      user.admin = false
      user.cleared = false
      user.save
      redirect_to :root, :notice => "Registrerad! Nu kan du logga in."

#      render :text => "Hi #{user.name}! You've signed up."
    end
  end

  def failure
    render :text => "Sorry, det gick bananas!"
  end
  
  def destroy
    session[:user_id] = nil
#    render :text => "You've logged out!"
    redirect_to :back
  end
end
