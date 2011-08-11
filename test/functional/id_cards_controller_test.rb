require 'test_helper'

class IdCardsControllerTest < ActionController::TestCase
  setup do
    @id_card = id_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:id_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create id_card" do
    assert_difference('IdCard.count') do
      post :create, :id_card => @id_card.attributes
    end

    assert_redirected_to id_card_path(assigns(:id_card))
  end

  test "should show id_card" do
    get :show, :id => @id_card.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @id_card.to_param
    assert_response :success
  end

  test "should update id_card" do
    put :update, :id => @id_card.to_param, :id_card => @id_card.attributes
    assert_redirected_to id_card_path(assigns(:id_card))
  end

  test "should destroy id_card" do
    assert_difference('IdCard.count', -1) do
      delete :destroy, :id => @id_card.to_param
    end

    assert_redirected_to id_cards_path
  end
end
