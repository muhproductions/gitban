require 'test_helper'

class AssigneesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assignee = assignees(:one)
  end

  test "should get index" do
    get assignees_url
    assert_response :success
  end

  test "should get new" do
    get new_assignee_url
    assert_response :success
  end

  test "should create assignee" do
    assert_difference('Assignee.count') do
      post assignees_url, params: { assignee: { name: @assignee.name, username: @assignee.username } }
    end

    assert_redirected_to assignee_url(Assignee.last)
  end

  test "should show assignee" do
    get assignee_url(@assignee)
    assert_response :success
  end

  test "should get edit" do
    get edit_assignee_url(@assignee)
    assert_response :success
  end

  test "should update assignee" do
    patch assignee_url(@assignee), params: { assignee: { name: @assignee.name, username: @assignee.username } }
    assert_redirected_to assignee_url(@assignee)
  end

  test "should destroy assignee" do
    assert_difference('Assignee.count', -1) do
      delete assignee_url(@assignee)
    end

    assert_redirected_to assignees_url
  end
end
