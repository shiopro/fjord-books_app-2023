# frozen_string_literal: true

require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :books
  fixtures :users

  setup do
    @user = users(:default_user)
    sign_in @user
    @book = books(:one)
  end

  test 'should get index' do
    get books_path
    assert_response :success
  end

  test 'should get new' do
    get new_book_path
    assert_response :success
  end

  test 'should create book' do
    assert_difference('Book.count') do
      post books_path, params: { book: { memo: @book.memo, title: @book.title } }
    end

    assert_redirected_to book_url(Book.last)
  end

  test 'should show book' do
    get book_path(@book)
    assert_response :success
  end

  test 'should get edit' do
    get edit_book_path(@book)
    assert_response :success
  end

  test 'should update book' do
    patch book_path(@book), params: { book: { memo: @book.memo, title: @book.title } }
    assert_redirected_to book_url(@book)
  end

  test 'should destroy book' do
    assert_difference('Book.count', -1) do
      delete book_path(@book)
    end

    assert_redirected_to books_url
  end
end
