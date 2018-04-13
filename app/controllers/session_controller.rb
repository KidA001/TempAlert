# frozen_string_literal: true

class SessionController < ApplicationController

  def create
    auth_code = params[:code]
    access_token = Google::OAuth.fetch_access_token(auth_code)
    @google_user = Google::User.new(access_token)
    find_or_create_user!
    create_session!
    redirect_to settings_path
  end

  private

  def find_or_create_user!
    @user = User.find_by_google_id(@google_user.id) ||
            User.create(create_user_params)
  end

  def create_user_params
    {
      name: @google_user.name,
      google_id: @google_user.id,
      email: @google_user.email,
      photo_url: @google_user.photo_url
    }
  end

  def create_session!
    session[:user_id] = @user.id
    session[:expires_at] = 20.days.from_now
  end
end
