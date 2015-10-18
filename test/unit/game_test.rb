require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "finalize game, recalc points fast" do
    game = games :game_nor_den
    game.final = true
    game.save!
    petter = users :user_petter
    petter_pts = petter.points ||= 0
    game.recalculate_points_fast!
    petter.reload
    assert(petter.points == petter_pts + 3, "Petter did not get his 3 points")
  end
end
