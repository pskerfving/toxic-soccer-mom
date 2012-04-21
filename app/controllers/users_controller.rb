# coding: UTF-8

class UsersController < ApplicationController


  def index
    @users = User.order("points DESC")
    setup_latest_game_tip_hash
    @first_game_started = first_game_started?

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end

  end

  def show
    
    @user = User.find(params[:id])
    @tips = @user.tips
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
    @authorizations = Authorization.where(:user_id => @user.id)
    @authorizations.each { |a| a.destroy }
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
