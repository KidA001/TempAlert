# frozen_string_literal: true

class User < ApplicationRecord
  validates :google_id, presence: true
  validates :name, presence: true
  validates :email, presence: true
end
