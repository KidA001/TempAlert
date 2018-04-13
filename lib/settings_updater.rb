# frozen_string_literal: true

class SettingsUpdater

  def initialize(user, params)
    @user = user
    @params = params
  end

  def perform!
    update_user!
    update_ideal_temp_subscription!
    update_extended_use_subscription!
    true
  end

  private

  def update_user!
    @user.update!(
      phone: Phoner::Phone.parse(@params[:phone]).format("%a%n"),
      email: @params[:email]
    )
  end

  def update_ideal_temp_subscription!
    Subscription.where(user: @user, type: :ideal_temperature).first_or_initialize.tap do |sub|
      sub.sms_enabled = @params[:ideal_temperature][:sms].values.include?('true')
      sub.email_enabled = @params[:ideal_temperature][:email].values.include?('true')
      sub.metadata = { ideal_temperature: @params[:ideal_temperature][:temp].to_i }
      sub.save!
    end
  end

  def update_extended_use_subscription!
    Subscription.where(user: @user, type: :extended_use).first_or_initialize.tap do |sub|
      sub.sms_enabled = @params[:extended_use][:sms].values.include?('true')
      sub.email_enabled = @params[:extended_use][:email].values.include?('true')
      sub.save!
    end
  end
end
