# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl if Rails.env.production?

  private

  def validate_session!
    return if valid_session?
    destroy_session!
    redirect_to auth_path
  end

  def valid_session?
    (session[:expires_at] && session[:expires_at] > Time.current) &&
      current_user.present?
  end

  def destroy_session!
    session.clear
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
end
