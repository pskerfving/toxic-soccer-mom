# coding: UTF-8

class SessionsController < ApplicationController

  def new
    @identity = env['omniauth.identity']
    @show_banner = false;
  end

  def signup
    @show_banner = false;
  end

  def create
    puts env['omniauth.auth'].to_yaml

    auth_hash = request.env['omniauth.auth']

    # Try to find an authorization
    @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    if @authorization
      # Set the user from the authorization we found
      session[:user_id] = @authorization.user.id
      if @authorization.user.email_verified
        redirect_to :root, :notice => "Du är inloggad. Lycka till med tippningen!"
      else
        redirect_to :root, :notice => "Du är nu inloggad. För att kunna tippa måste du först bekräfta din mail-adress. Titta i din inbox."
      end
    else
      # No authorization found. Create a new user and an authorization from the info provided
      puts "---------------- HITTADE INGEN PERSON"
      user = User.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
      puts user.name
      puts user.email
      @authorization = user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      puts "---------------- SKAPAT AUTH"
      user.admin = false
      user.cleared = false
      user.points = 0
      # Om email finns, men inte är verifierad. Skicka mail för att få det verifierat.
      if @authorization.provider == "identity"
        user.email_verified = false
        user.save!  # Too many saves here.
        user.send_email_verification
        redirect_to :root, :notice => "Ditt konto är skapat. Du måste bekräfta din mailadress. Titta i din inbox."
      end
      if @authorization.provider == "twitter"
        user.email_verified = false
        user.save!
        redirect_to email_user_path(user), :notice => 'Ditt konto är skapat. Du behöver komplettera med en mailadress.'
      end
      if @authorization.provider == "facebook"
        user.email_verified = true
        user.save!
        if user.email
          UserMailer.welcome(user).deliver
          redirect_to :root
        else
          redirect_to email_user_path(user), :notice => 'Ditt konto är skapat. Du behöver komplettera med en mailadress.'
        end
      end
      session[:user_id] = user.id
    end
  end

  def failure
    render :text => "Beklagar, det gick bananas!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root # TODO: Borde vara :back.
  end
end
