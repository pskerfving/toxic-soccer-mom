# coding: UTF-8
class StatsController < ApplicationController

  def stats
    @nbr_users = User.all.length
    @nbr_tips = WinnersTip.all.length
    @nbr_wine = User.where(:wine => true).length
    @nbr_days_wine = time_until_wine_deadline
    @nbr_days_register = time_until_first_game
  end

  def time_until_wine_deadline
    deadline = Time.utc(2012, "jun", 15)
    return ((deadline - Time.now)/(3600*24) + 1).round
  end

  def time_until_first_game
    first_game = Game.order('kickoff').first
    return ((first_game.kickoff - Time.now)/(3600*24) + 1).round
  end

end
