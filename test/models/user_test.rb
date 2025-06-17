# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  test '#name_or_email' do
    user = users(:default_user)

    assert_equal 'Foo', user.name_or_email

    user.name = ''
    assert_equal 'foo@example.com', user.name_or_email
  end
end
