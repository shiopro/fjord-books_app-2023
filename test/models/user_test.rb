# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  test '#name_or_email' do
    user = users(:default_user)

    assert_equal '山田太郎', user.name_or_email

    user.name = ''
    assert_equal 'yamada@example.com', user.name_or_email
  end
end
