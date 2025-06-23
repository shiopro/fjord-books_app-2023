# frozen_string_literal: true

require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :reports
  fixtures :users

  setup do
    @user = users(:default_user)
    sign_in @user
    @report = reports(:foo)
  end

  test 'should get index' do
    get reports_path
    assert_response :success
  end

  test 'should get new' do
    get new_report_path
    assert_response :success
  end

  test 'should create report' do
    assert_difference('Report.count') do
      post reports_url, params: { report: { content: @report.content, title: @report.title } }
    end

    assert_redirected_to report_url(Report.last)
  end

  test 'should show report' do
    get report_path(@report)
    assert_response :success
  end

  test 'should get edit' do
    get edit_report_path(@report)
    assert_response :success
  end

  test 'should update report' do
    patch report_path(@report), params: { report: { content: @report.content, title: @report.title } }
    assert_redirected_to report_path(@report)
  end

  test 'should destroy report' do
    assert_difference('Report.count', -1) do
      delete report_path(@report)
    end

    assert_redirected_to reports_url
  end
end
