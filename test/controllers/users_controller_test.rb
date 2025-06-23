# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users

  setup do
    @user = users(:default_user)
    sign_in @user
  end

  test 'should get index' do
    get users_path
    assert_response :success
  end

  test 'should get show' do
    get user_path(@user)
    assert_response :success
  end
end
