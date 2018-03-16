# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  validates :user, uniqueness: { scope: :type }
  validates :metadata, has_temperature: true, if: -> { ideal_temperature? }

  scope :extended_use, -> { where(type: :extended_use) }
  scope :active, -> { where('sms_enabled is true OR email_enabled is true') }
  scope :ideal_temp, -> (temp) do
    where(type: :ideal_temperature).
    where("(metadata->>'ideal_temperature')::int <= ?", temp)
  end

  TYPES = {
      ideal_temperature: 0,
      extended_use: 1
    }.freeze

  enum type: TYPES

  def self.inheritance_column
    nil
  end
end
