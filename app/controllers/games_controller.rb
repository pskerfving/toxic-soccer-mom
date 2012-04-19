class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    @games = Game.order("kickoff")
    if params[:show] == "upcoming"
      @games = Game.where(:final => false)
#      @games.delete_if { |g| g.final? }
    else
      @games = Game.order("kickoff")
    end
      
    # Find all tips for the currently logged in user
    setup_user_tips_hash
    setup_winners_right_now
    calculate_odds

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        recalculate_points
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        recalculate_points
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  def ajax_update_score
    @game = Game.find(params[:id])
    team = params[:team]
    adjust = params[:adjust]
    if team == "home"
      @game.home_score += Integer(adjust)
      if @game.home_score < 0 then @game.home_score = 0 end
    else
      @game.away_score += Integer(adjust)
      if @game.away_score < 0 then @game.away_score = 0 end
    end
    @game.save

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { render json: @game }
    end
  end

  def ajax_update_tip
    @game = Game.find(params[:id])
    team = params[:team]
    adjust = params[:adjust]
    @tip = Tip.find(:first, :conditions => ["user_id = ? and game_id = ?", current_user.id, @game.id])
    if !@tip
      # The user has not made a tip for this game
      @tip = Tip.new
      @tip.user = current_user
      @tip.game = @game
      @tip.home_score = 0;    # TODO: This is not the right place for this initialization!!
      @tip.away_score = 0;    # TODO: This is not the right place for this initialization!!
      @tip.save
    else
      # Adjusting an existing tip
      if team == "home"
        @tip.home_score += Integer(adjust)
        if @tip.home_score < 0 then @tip.home_score = 0 end
      else
        @tip.away_score += Integer(adjust)
        if @tip.away_score < 0 then @tip.away_score = 0 end
      end
      @tip.save
    end

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { render json: @tip }
    end
  end

  # PUT /games/1/finalize
  # For setting the game as final (complete, over, finito).
  # Requires admin
  def finalize
    if current_user && current_user.admin?
      @game = Game.find(params[:id])
      @game.final = true
      @game.save

      respond_to do |format|
        format.html { redirect_to games_url }
        format.json { head :no_content }
      end
    end
  end
    
end
