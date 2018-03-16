# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  validates :user, uniqueness: { scope: :type }
  validates :metadata, has_temperature: true, if: -> { ideal_temperature? }

  TYPES = {
      ideal_temperature: 0,
      extended_use: 1
    }.freeze

  enum type: TYPES

  def self.inheritance_column
    nil
  end
end
