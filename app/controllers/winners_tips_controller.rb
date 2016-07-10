# coding: UTF-8
class WinnersTipsController < ApplicationController

  before_filter :cleared_required, :only => [:index, :edit, :update, :create, :show, :new, :destroy]
  before_filter :first_game_not_started_required, :only => [:edit, :update, :new]
  before_filter :first_game_started_required, :only => [:index]
  before_filter :users_own_winners_tip_required, :only => [:show, :edit, :update, :destroy]

  # GET /winners_tips
  # GET /winners_tips.json
  def index
    @winners_tips = WinnersTip.joins(:user).order("users.points DESC, name ASC").where(:key => false)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @winners_tips }
    end
  end

  # GET /winners_tips/1
  # GET /winners_tips/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @winners_tip }
    end
  end

  # GET /winners_tips/new
  # GET /winners_tips/new.json
  def new
    @show_banner = false
    @winners_tip = WinnersTip.new
    @winners_tip.user = current_user
    user_tip = WinnersTip.where(:user_id => current_user).first
    if user_tip
      redirect_to current_user, notice: 'Du har redan sparat ditt grundtips.'
      return
    end
    setup_selectable_teams_and_players

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @winners_tip }
    end
  end

  # GET /winners_tips/1/edit
  def edit
    setup_selectable_teams_and_players
  end

  # POST /winners_tips
  # POST /winners_tips.json
  def create
    @winners_tip = WinnersTip.new(params[:winners_tip])
    # Check that the user has not already created a tip.
    user_tip = WinnersTip.where(:user_id => current_user).first
    if user_tip
      redirect_to current_user, notice: 'Du har redan sparat ditt grundtips.'
      return
    end
    @winners_tip.user = current_user

    respond_to do |format|
      if @winners_tip.save
        format.html { redirect_to :back, notice: 'Ditt grundtips har sparats.' }
        format.json { render json: @winners_tip, status: :created, location: @winners_tip }
      else
        format.html { render action: "new" }
        format.json { render json: @winners_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /winners_tips/1
  # PUT /winners_tips/1.json
  def update

    respond_to do |format|
      if @winners_tip.update_attributes(params[:winners_tip])
        if @winners_tip.key?
          # We are saving the key ->
          # Recalculate all winnerstip points
          tips = WinnersTip.where(:key => false)
          tips.each do |i|
            i.calculate_winners_points(@winners_tip)
            puts "--------------------- POINTS"
            puts i.points
            # add the points to the users total.
            i.user.points += i.points
            # save both tip and user
            i.save!
            i.user.save!
          end
        end
        format.html { redirect_to @user, notice: 'Ditt tips har sparats.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @winners_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /winners_tips/1
  # DELETE /winners_tips/1.json
  def destroy
    @winners_tip.destroy

    respond_to do |format|
      format.html { redirect_to winners_tips_url }
      format.json { head :no_content }
    end
  end

  def winnerstipskey
    @winners_tip = WinnersTip.where(:key => true).first
    if !@winners_tip then
      @winners_tip = WinnersTip.new
      @winners_tip.user = current_user
      @winners_tip.winning_team_id = 0
      @winners_tip.runner_up_id = 0
      @winners_tip.topscorer_player_id = 0
      @winners_tip.firstswedish_player_id = 0
      @winners_tip.key = true
      @winners_tip.save
    end

    redirect_to edit_winners_tip_path(@winners_tip)

  end

  # Remove all placeholders so they are not shown in the selectboxes.
  def setup_selectable_teams_and_players
    @teams = Team.order("country").reject { |t| t.placeholder? }
    @players = Player.order("name")
  end

  # Before_filter to assure that you do not update someone elses tips.
  def users_own_winners_tip_required
    @winners_tip = WinnersTip.find(params[:id])
    if current_user && current_user.admin?
      @user = current_user
      return
    end

    @user = User.find(@winners_tip.user)

    if @user != current_user && current_user && !current_user.admin?
      redirect_to :root, notice: "Detta verkar inte vara ditt tips."
    end
  end

end
