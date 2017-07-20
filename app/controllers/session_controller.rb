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
    @subscriber = begin
      Subscriber.find_by_google_id(@google_user.id) ||
        Subscriber.create(create_subscriber_params)
    end
  end

  def create_subscriber_params
    {
      name: @google_user.name,
      google_id: @google_user.id,
      email: @google_user.email,
      photo_url: @google_user.photo_url
    }
  end

  def create_session!
    session[:subscriber_id] = @subscriber.id
    session[:expires_at] = 20.days.from_now
  end
end
