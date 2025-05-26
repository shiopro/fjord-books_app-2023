# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :report_mentions, class_name: 'ReportMention', foreign_key: 'source_report_id', inverse_of: :source_report, dependent: :destroy
  has_many :mentioning_reports, through: :report_mentions, source: :target_report

  has_many :mentions_received, class_name: 'ReportMention', foreign_key: 'target_report_id', inverse_of: :target_report, dependent: :destroy
  has_many :mentioned_reports, through: :mentions_received, source: :source_report

  validates :title, presence: true
  validates :content, presence: true

  after_save :save_mentions

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_mentions
    report_mentions.destroy_all
    ids = content.to_s.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.uniq
    reports = Report.where(id: ids).where.not(id:)
    self.mentioning_reports = reports
  end
end
