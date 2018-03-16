# frozen_string_literal: true

class User < ApplicationRecord
  validates :google_id, presence: true
  validates :name, presence: true
  validates :email, presence: true

  has_many :subscriptions, dependent: :destroy

  def subscription_for(type)
    Subscription.where(
      user: self,
      type: type
    ).first_or_initialize
  end

end
