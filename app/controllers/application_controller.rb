# coding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  def initialize
    super
    @show_banner = true
  end

  def current_user
    if session[:user_id]
      current_user ||= User.find(session[:user_id])
    else
      current_user = nil
    end
  end

  def login_required
    redirect_to("/login", notice: 'Vv logga in.') if current_user
  end

  # Check that the user is logged in and admin
  def admin_required
    redirect_to("/login", notice: 'Logga in som administratör.') if current_user && current_user.admin
  end

  # Check that the user accessing his own records
  def own_user_or_admin_required
    if current_user
      if (current_user.id == params[:id]) || current_user.admin
        return
      end
    end
    redirect_to "/login", notice: 'Logga in som denna användare för att ändra uppgifter.'
  end


  #TODO: These should be overridden if the user is admin.

  # Check that the user is logged in, and that that person has been cleared to place bets
  def cleared_required
    if current_user
      if current_user.cleared
        return
      end
      raise 'Du är ännu inte godkänd för att tippa.'
    end
    redirect_to "/login", notice: 'Logga in för att tippa.'
  end

  def first_game_not_started_required
    first_game = Game.order('kickoff').first
    if first_game.kickoff < Time.zone.now && current_user && !current_user.admin?
      redirect_to :root, notice: 'Går inte att göra eftersom första matchen redan har börjat.'
    end
  end

  def first_game_started_required
    first_game = Game.order('kickoff').first
    if first_game.kickoff > Time.zone.now && current_user && !current_user.admin?
      redirect_to :root, notice: 'Går inte att göra eftersom första matchen har inte startat.'
    end
  end


  # Do the full recalculate of the points for all users
  # TODO: Add the winners_tips to the calculation
  # TODO: Check that all this saving is efficient
  def recalculate_points
    # First, clear the points for all users and add any winners_tips points.
    users = User.all
    users.each do |u|
      u.points = 0
      if u.admin?
        # If we don't do this, there is a risk that we get the key and not "the other" winners_tip
        u.winners_tip = WinnersTip.where(:user_id => u.id, :key => false).first
      end
      if u.winners_tip
        u.points = u.winners_tip.points
      end
      u.save
    end

    # Loop through all games and add the points
    games = Game.all
    games.each do |game|
      if game.final? then
        tips = game.tips
        tips.each do |tip|
          tip.user.points += tip.points
          tip.user.save
        end
      end
    end
  end


  protected

  # Setup a hash of the tips the current user has made.
  # For use in the main view for finding what tips the user has for differenyt games.
  # Call this before using partial _games
  def setup_user_tips_hash
    @user_tips_hash = Hash.new
    if current_user
      @user_tips = Tip.where("user_id = ?", current_user.id)
      @user_tips.each {|t| @user_tips_hash[t.game_id] = t }    
    end
  end

  # Call this before using partial _games
  def setup_winners_right_now
    # create a Hash with ongoing games
    @honorable_hash = Hash.new
    @games.each do |g|
      if g.started?
        tips = Tip.joins(:user).where("game_id =? and home_score = ? and away_score = ?", g.id, g.home_score, g.away_score).order("users.points DESC")
        @honorable_hash[g.id] = tips
      end
    end
  end


end
