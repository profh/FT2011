require 'test_helper'

class MeasurementCategoriesControllerTest < ActionController::TestCase
  setup do
    @measurement_category = measurement_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:measurement_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create measurement_category" do
    assert_difference('MeasurementCategory.count') do
      post :create, :measurement_category => @measurement_category.attributes
    end

    assert_redirected_to measurement_category_path(assigns(:measurement_category))
  end

  test "should show measurement_category" do
    get :show, :id => @measurement_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @measurement_category.to_param
    assert_response :success
  end

  test "should update measurement_category" do
    put :update, :id => @measurement_category.to_param, :measurement_category => @measurement_category.attributes
    assert_redirected_to measurement_category_path(assigns(:measurement_category))
  end

  test "should destroy measurement_category" do
    assert_difference('MeasurementCategory.count', -1) do
      delete :destroy, :id => @measurement_category.to_param
    end

    assert_redirected_to measurement_categories_path
  end
end
