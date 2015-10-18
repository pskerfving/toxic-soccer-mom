require 'test_helper'

class TipTest < ActiveSupport::TestCase

  test "prohibit multiple tips (same user & game)" do
    tip = Tip.new
    tip.user = users :user_petter
    tip.game = games :game_swe_nor
    assert(not(tip.save), "Possible to save multiple tips for same user/game")
  end

  test "prohibit save incomplete tip" do
    tip = Tip.new
    assert(not(tip.save), "Possible to save incomplete tip (user & game missing)")
    tip.user = users(:user_gunhild)
    assert(not(tip.save), "Possible to save incomplete tip (game missing)")
    tip.game = games(:game_nor_den)
    assert(tip.save, "Not possible to save complete tip.")
  end

  test "calculate tip points" do
    tip = tips(:petter_tip_swe_nor)
    assert_equal(3, tip.calculate_points, "Tip points not currently calculated, correct result")
    tip = tips(:lennart_tip_swe_nor)
    assert_equal(2, tip.calculate_points, "Tip points not currently calculated, correct token")
    tip = tips(:gunhild_tip_swe_nor)
    assert_equal(0, tip.calculate_points, "Tip points not currently calculated, wrong")
  end
end
