# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :validate_session!

  def index
    @ideal_temp_subscription = current_user.subscription_for(:ideal_temperature)
    @extended_use_subscription = current_user.subscription_for(:extended_use)
  rescue => e
    Notice.error(e)
    flash[:error] = "Sorry, something is borked"
    redirect_to root_path
  end

  def update
    updater = SettingsUpdater.new(current_user, permitted_params)
    updater.perform!

    flash[:success] = "Your settings have been saved <3"
    redirect_to settings_path
  rescue => e
    Notice.error(e)
    flash[:error] = "Sorry, something is borked"
    redirect_to settings_path
  end

  private

  def permitted_params
    params.permit(:email, :phone, ideal_temperature: {}, extended_use: {})
  end
end
