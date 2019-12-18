# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :validate_session!

  def index;end

  def update
    current_user.update!(permitted_params)

    flash[:success] = "Your settings have been saved <3"
    redirect_to settings_path
  rescue => e
    Notice.error(e)
    flash[:error] = "Sorry, something is borked"
    redirect_to settings_path
  end

  private

  def permitted_params
    params.permit(:email, :phone)
  end
end
