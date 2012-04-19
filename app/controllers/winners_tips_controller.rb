class WinnersTipsController < ApplicationController

  before_filter :cleared_required, :only => [:index, :edit, :update]
  before_filter :first_game_not_started_required, :only => [:index, :edit, :update]

  # GET /winners_tips
  # GET /winners_tips.json
  def index
    @winners_tips = WinnersTip.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @winners_tips }
    end
  end

  # GET /winners_tips/1
  # GET /winners_tips/1.json
  def show
    @winners_tip = WinnersTip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @winners_tip }
    end
  end

  # GET /winners_tips/new
  # GET /winners_tips/new.json
  def new
    @winners_tip = WinnersTip.new
    @winners_tip.user = current_user
    setup_selectable_teams

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @winners_tip }
    end
  end

  # GET /winners_tips/1/edit
  def edit
    @winners_tip = WinnersTip.find(params[:id])
    setup_selectable_teams
  end

  # POST /winners_tips
  # POST /winners_tips.json
  def create
    @winners_tip = WinnersTip.new(params[:winners_tip])
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
    @winners_tip = WinnersTip.find(params[:id])

    respond_to do |format|
      if @winners_tip.update_attributes(params[:winners_tip])
        format.html { redirect_to @winners_tip, notice: 'Winners tip was successfully updated.' }
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
    @winners_tip = WinnersTip.find(params[:id])
    @winners_tip.destroy

    respond_to do |format|
      format.html { redirect_to winners_tips_url }
      format.json { head :no_content }
    end
  end

  # Remove all placeholders so they are not shown in the selectboxes.
  def setup_selectable_teams
    @teams = Team.order("country")
    @teams.delete_if { |t| t.placeholder? }
  end
end
