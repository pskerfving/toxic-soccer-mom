class StatsController < ApplicationController

  def stats
    @nbr_users = User.all.length
    @nbr_tips = WinnersTip.all.length
    @nbr_wine = User.where(:wine => true).length
  end

end
