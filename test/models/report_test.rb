# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  fixtures :reports
  fixtures :users
  test '#editable?' do
    report = reports(:one)
    user = users(:default_user)
    other_user = users(:another_user)

    assert report.editable?(user)
    assert_not report.editable?(other_user)
  end

  test '#created_on' do
    report = Report.new(
      title: 'テストです',
      content: 'テスト',
      user: users(:default_user),
      created_at: Time.zone.local(2025, 6, 18, 12, 0, 0)
    )

    assert_equal Date.new(2025, 6, 18), report.created_on
  end

  test '#save_mentions' do
    mentioned = reports(:one)
    mentioning = reports(:two)

    mentioning.save

    assert_includes(mentioning.mentioning_reports, mentioned)
    assert_not_includes(mentioned.mentioning_reports, mentioning)

    # mentioned の content に mentioning のリンクを埋め込み、逆メンション
    mentioned.update(content: 'http://localhost:3000/reports/2')
    mentioning.update(content: 'テストです')

    assert_includes(mentioned.reload.mentioning_reports, mentioning)
    assert_not_includes(mentioning.reload.mentioning_reports, mentioned)

    # 新規レポートを作成し、mentioned が新規レポートをメンション
    another_report = Report.create!(id: 3, user: users(:another_user), title: 'テスト用', content: 'テストテキスト')
    mentioned.update(content: 'http://localhost:3000/reports/3')

    assert_includes(mentioned.reload.mentioning_reports, another_report)

    # メンションを削除するケース
    mentioned.update(content: '文章のみです')

    assert_not_includes(mentioned.reload.mentioning_reports, mentioning)

    # メンション対象の日報を削除するケース
    mentioned.destroy

    assert_not_includes(mentioning.reload.mentioning_reports, mentioned)
  end
end
