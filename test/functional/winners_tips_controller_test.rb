require 'test_helper'

class WinnersTipsControllerTest < ActionController::TestCase
  setup do
    @winners_tip = winners_tips(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:winners_tips)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create winners_tip" do
    assert_difference('WinnersTip.count') do
      post :create, winners_tip: @winners_tip.attributes
    end

    assert_redirected_to winners_tip_path(assigns(:winners_tip))
  end

  test "should show winners_tip" do
    get :show, id: @winners_tip
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @winners_tip
    assert_response :success
  end

  test "should update winners_tip" do
    put :update, id: @winners_tip, winners_tip: @winners_tip.attributes
    assert_redirected_to winners_tip_path(assigns(:winners_tip))
  end

  test "should destroy winners_tip" do
    assert_difference('WinnersTip.count', -1) do
      delete :destroy, id: @winners_tip
    end

    assert_redirected_to winners_tips_path
  end
end
