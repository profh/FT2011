require 'test_helper'

class OrganizationTypesControllerTest < ActionController::TestCase
  setup do
    @organization_type = organization_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_type" do
    assert_difference('OrganizationType.count') do
      post :create, :organization_type => @organization_type.attributes
    end

    assert_redirected_to organization_type_path(assigns(:organization_type))
  end

  test "should show organization_type" do
    get :show, :id => @organization_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @organization_type.to_param
    assert_response :success
  end

  test "should update organization_type" do
    put :update, :id => @organization_type.to_param, :organization_type => @organization_type.attributes
    assert_redirected_to organization_type_path(assigns(:organization_type))
  end

  test "should destroy organization_type" do
    assert_difference('OrganizationType.count', -1) do
      delete :destroy, :id => @organization_type.to_param
    end

    assert_redirected_to organization_types_path
  end
end
