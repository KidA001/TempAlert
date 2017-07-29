class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl

  private

  def validate_session!
    return if valid_session?
    destroy_session!
    redirect_to auth_path
  end

  def valid_session?
    (session[:expires_at] && session[:expires_at] > Time.current) &&
      current_subscriber.present?
  end

  def destroy_session!
    session.clear
  end

  def current_subscriber
    @current_subscriber ||= Subscriber.find_by_id(session[:subscriber_id])
  end
end
