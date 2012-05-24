# coding: UTF-8

class UsersController < ApplicationController

  before_filter :admin_required, :only => [:new, :edit, :update, :create, :destroy]

  def index
    if params[:show] == "unapproved"
      @users = User.where(:cleared => false)
    else
      @users = User.where(:cleared => true).order("points DESC")
    end
    setup_latest_game_tip_hash
    @first_game_started = first_game_started?

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end

  end

  def show

    @user = User.find(params[:id])
    @tips = Tip.joins(:user, :game).where(:user_id => params[:id]).order("kickoff") # Lite krångligt för att kunna sortera på kickoff.
    @winners_tip = @user.winners_tip
    @first_game_started = first_game_started?    # För att komma åt fr vy. Fattar inte riktigt hur scopen funkar.

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        @user.send_user_cleared
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin?
      #You cannot delete an administrator, first set as a regular user.
      redirect_to :users, notice: 'Du kan inte ta bort en administrator. Ta bort användarens behörighet först.'
    end
    # Delete all information related to the user (authorizations, tips and comments)
    auth = Authorization.where(:user_id => @user.id)
    auth.each { |i|
      if i.provider = "identity"
        id = Identity.find(i.uid)
        id.destroy
      end
      i.destroy
    }
    wt = WinnersTip.where(:user_id => @user.id)
    wt.each { |i| i.destroy }
    tips = Tip.where(:user_id => @user.id)
    tips.each { |i| i.destroy }
    comm = Comment.where(:user_id => @user.id)
    comm.each { |i| i.destroy }
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  def setup_latest_game_tip_hash
    @latest_games = Game.where('kickoff < ?', Time.zone.now).order("kickoff").limit(5)
    @latest_game_tip_hash = Hash.new
    @latest_games.each do |g|
      @latest_game_tip_hash[g.id] = Hash.new
      g.tips.each do |t|
        @latest_game_tip_hash[g.id][t.user_id] = t
      end
    end    
  end
  
end
