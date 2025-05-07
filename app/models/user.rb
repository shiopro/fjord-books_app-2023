# frozen_string_literal: true

class User < ApplicationRecord
  validate :verify_file_type
  has_one_attached :icon
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  def verify_file_type
    return unless icon.attached?

    allowed_file_types = %w[image/jpeg image/png image/gif]
    errors.add(:icon, :invalid_file_type) unless allowed_file_types.include?(icon.blob.content_type)
  end
end
