# coding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  
  def current_user
    if session[:user_id]
      current_user ||= User.find(session[:user_id])
    else
      current_user = nil
    end
  end

  def login_required
    if current_user
      return
    end
    redirect_to "/login", notice: 'Vv logga in.'
  end

  # Check that the user is logged in and admin
  def admin_required
    if current_user && current_user.admin
      return
    end
    redirect_to "/login", notice: 'Logga in som administratör.'
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
      redirect_to :root, notice: 'Första matchen har börjat. Det är för sent att ändra grundtips.'
    end
  end

  def first_game_started_required
    first_game = Game.order('kickoff').first
    if first_game.kickoff > Time.zone.now && current_user && !current_user.admin?
      redirect_to :root, notice: 'Första matchen har inte startat.'
    end
  end


  # Do the full recalculate of the points for all users
  # TODO: Add the winners_tips to the calculation
  # TODO: Check that all this saving is efficient
  def recalculate_points
    # First, clear the points for all users
    users = User.all
    users.each { |u| u.points = 0; u.save }

    games = Game.all
    games.each do |game|
      if game.final? then
        tips = game.tips
        tips.each do |tip|
          tip.points = calculate_tip_points(tip)
          tip.user.points += tip.points
          tip.save
          tip.user.save
        end
      end
    end
  end

  def calculate_tip_points(t)
    if (t.home_score == t.game.home_score) && (t.away_score == t.game.away_score)
      return 3
    end
    if game_token(t.home_score, t.away_score) == game_token(t.game.home_score, t.game.away_score)
      return 2
    end
    return 0
  end

  def game_token(home, away)
    # token 1, function returns -1
    # token X, function returns 0
    # token 2, function returns 1
    if (away - home) < 0
      return -1
    end
    if (away - home) > 0
      return 1
    end
    return 0
  end


  def first_game_started?
    Game.order(:kickoff).first().kickoff < Time.zone.now()
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
        tips = Tip.where("game_id =? and home_score = ? and away_score = ?", g.id, g.home_score, g.away_score)
        @honorable_hash[g.id] = tips
      end
    end
  end

  def calculate_odds
    @odds_hash = Hash.new
    @games.each do |g|
      if g.started?
        @odds_hash[g.id] = Hash.new
        @odds_hash[g.id][-1] = Float(0)
        @odds_hash[g.id][0] = Float(0)
        @odds_hash[g.id][1] = Float(0)
        g.tips.each do |t|
          token = game_token t.home_score, t.away_score
          @odds_hash[g.id][token] += 1
#          (@odds_hash[g.id][token] == nil) ? @odds_hash[g.id][token] = 1 : @odds_hash[g.id][token] += 1
        end # tips-loop

#        @odds_hash[g.id].collect { |i| g.tips.length / i }
        [-1, 0, 1].each do |i|
          if @odds_hash[g.id][i] > 0
            @odds_hash[g.id][i] = g.tips.length / @odds_hash[g.id][i]
          else
            @odds_hash[g.id][i] = nil
          end
        end # nbr -> odds - loop
      end # game-loop
    end
  end

end
