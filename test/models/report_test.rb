# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  fixtures :reports
  fixtures :users
  test '#editable?' do
    report = reports(:foo)
    user = users(:default_user)
    other_user = users(:another_user)

    assert report.editable?(user)
    assert_not report.editable?(other_user)
  end

  test '#created_on' do
    report = Report.create!(
      title: 'テストです',
      content: 'テスト',
      user: users(:default_user),
      created_at: Time.zone.local(2025, 6, 18, 12, 0, 0)
    )

    assert_equal Date.new(2025, 6, 18), report.created_on
    assert_not_equal Date.new(2025, 6, 17), report.created_on
  end

  test '#save_mentions' do
    report1 = reports(:foo)
    report2 = reports(:bob)

    report2.send(:save_mentions)

    assert_includes(report2.mentioning_reports, report1)
    assert_not_includes(report1.mentioning_reports, report2)

    report1.update(content: 'http://localhost:3000/reports/2')
    report2.update(content: 'テストです')

    report1.send(:save_mentions)
    report2.send(:save_mentions)

    assert_includes(report1.reload.mentioning_reports, report2)
    assert_not_includes(report2.reload.mentioning_reports, report1)

    report3 = Report.create!(id: 3, user: users(:another_user), title: 'テスト用', content: 'テストテキスト')
    report1.update(content: 'http://localhost:3000/reports/3')

    assert_includes(report1.reload.mentioning_reports, report3)

    report1.update(content: '文章のみです')
    report1.send(:save_mentions)

    assert_not_includes(report1.reload.mentioning_reports, report2)

    report2.destroy

    assert_not_includes(report1.reload.mentioning_reports, report2)
  end
end
