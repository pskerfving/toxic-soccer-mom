class GamesController < ApplicationController

  before_filter :admin_required, :only => [:new, :show, :edit, :update, :create, :destroy, :finalize]

  # GET /games
  # GET /games.json
  def index
    if params[:show] == "upcoming"
      @games = Game.where(:final => false).order("kickoff")
    else
      @games = Game.order("kickoff")
    end

    # Find all tips for the currently logged in user
    setup_user_tips_hash
    setup_winners_right_now
    @odds_hash = Game.calculate_odds(@games)

    # Get the leaders for the sidebar
    @leaders = User.order("points DESC").limit(10)

    # Find the latest comment. For the polling to work.
    @last_comment = Comment.order("updated_at DESC").first

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
        if @game.final? then
          recalculate_points
        end
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
    @game.comments.destroy_all
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end


  def getgamebox
    @games = Game.where("id = ? and updated_at > ?", params[:game_id], Time.at(params[:after].to_i + 1))

    if !@games.empty?
      setup_winners_right_now
    end
    
  end

  # Varför ligger denna här? Det beror egentligen mest på att den används i game#index och liknande.
  def getnewcomments
    # Find games with new comments.
    @games = Game.joins(:comments).where("comments.updated_at > ?", Time.at(params[:after].to_i + 1))
    # Find the latest comment for generating a new timestamp.
    @last_comment = Comment.order("updated_at DESC").first 
  end

  def getcommentform
    @game = Game.find(params[:game])
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

    recalculate_predicted

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { render json: @game }
    end
  end

  # Recalculate the predicted points if the score of ongoing games does not change.
  def recalculate_predicted

    # reset predicted to actual standing
    users = User.all
    users.each do |u|
      if u.predicted != u.points
        u.predicted = u.points
        u.save
      end
    end

    # find the ongoing games and iterate over them
    games = Game.where("kickoff < ? AND final <> true", Time.zone.now)
    games.each do |g|
      # get all tips for each game and interate of the tips
      tips = g.tips
      tips.each do |t|
        # update the predicted with the result form the ongoing game
        predict = t.calculate_points
        if predict != 0
          t.user.predicted += predict
          t.user.save
        end
      end
    end
  end

  def ajax_update_tip
    @game = Game.find(params[:id])
    if @game.started? then
      raise
    end
    team = params[:team]
    adjust = params[:adjust]
    if current_user == nil
      raise "************************** current_user is NIL!"
    end
    @tip = Tip.first(:conditions => ["user_id = ? and game_id = ?", current_user.id, @game.id])
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
    if current_user && current_user.admin? # Is this needed?
      @game = Game.find(params[:id])
      @game.final = true
      @game.save!
      @game.recalculate_points_fast!

      respond_to do |format|
        format.html { redirect_to games_url }
        format.json { head :no_content }
      end
    end
  end

end
