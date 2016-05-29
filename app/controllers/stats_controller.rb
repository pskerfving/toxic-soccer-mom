# coding: UTF-8
class StatsController < ApplicationController

  def stats
    @nbr_users = User.all.length
    @nbr_tips = WinnersTip.all.length
    @nbr_wine = User.where(:wine => true).length
    @nbr_days_wine = time_until_wine_deadline
    @nbr_days_register = time_until_first_game

    if current_user
      @winnerstip = WinnersTip.where(:user_id => current_user.id)
      @tips = Tip.where(:user_id => current_user.id)
      @wine = current_user.wine
      if @wine
        redirect_to games_path
      end
    end
    
    # Get the leaders for the sidebar
    @leaders = User.order("points DESC").limit(10)

  end

  def time_until_wine_deadline
    deadline = Time.utc(2016, "jun", 10)
    return ((deadline - Time.now)/(3600*24) + 1).round
  end

  def time_until_first_game
    first_game = Game.order('kickoff').first
    return ((first_game.kickoff - Time.now)/(3600*24) + 1).round
  end

end
