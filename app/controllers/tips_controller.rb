class TipsController < ApplicationController

  before_filter :get_game
  before_filter :cleared_required, :only => [:index, :edit, :update, :destroy. :show, :create]
  before_filter :game_not_started_required, :only => [:edit, :update, :create, :new]
  before_filter :admin_required, :only => [:index, :show, :destroy]

  # GET /tips
  # GET /tips.json
  def index
    @tips = @game.tips

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tips }
    end
  end

  # GET /tips/1
  # GET /tips/1.json
  def show
    @tip = @game.tips.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tip }
    end
  end

  # GET /tips/new
  # GET /tips/new.json
  def new
    @tip = @game.tips.build
    @tip.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tip }
    end
  end

  # GET /tips/1/edit
  def edit
    @tip = @game.tips.find(params[:id])
  end

  # POST /tips
  # POST /tips.json
  def create
    @tip = @game.tips.build(params[:tip])
    @tip.user = current_user

    respond_to do |format|
      if @tip.save
        format.html { redirect_to game_tips_url(@game), notice: 'Tip was successfully created.' }
        format.json { render json: @tip, status: :created, location: @tip }
      else
        format.html { render action: "new" }
        format.json { render json: @tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tips/1
  # PUT /tips/1.json
  def update
    @tip = @game.tips.find(params[:id])

    respond_to do |format|
        if @tip.update_attributes(params[:tip])
          format.html { redirect_to game_tips_url(@game), notice: 'Tip was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @tip.errors, status: :unprocessable_entity }
        end
    end
  end

  # DELETE /tips/1
  # DELETE /tips/1.json
  def destroy
    @tip = @game.tips.find(params[:id])
    @tip.destroy

    respond_to do |format|
      format.html { redirect_to game_tips_url(@game) }
      format.json { head :no_content }
    end
  end
  
  def correct?
    if home_score == game.home_scope && away_score == game.away_score
      return true
    end
    return false
  end
  
  private

  def get_game
    @game = Game.find(params[:game_id])
  end

  def game_not_started_required
    # TODO: This seems to get an offset. Probably related to timezones. Sort this out!
    # TODO: This should be in the Game Model.
    if @game.started?
      redirect_to game_tips_url(@game), notice: 'Game started. It is too late to place a bet.'
    end
  end

  
end
