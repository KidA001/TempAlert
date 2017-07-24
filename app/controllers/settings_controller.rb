class SettingsController < ApplicationController
  before_action :validate_session!

  def index
    @subscriber = current_subscriber
  rescue => e
    Notice.error(e)
  end

  def update
    current_subscriber.update!(update_params)
    flash[:success] = "Your settings have been saved <3"
    redirect_to settings_path
  rescue => e
    Notice.error(e)
    flash[:error] = "Sorry, something is borked"
    redirect_to settings_path
  end

  private

  def update_params
    {
      subscriptions: {
        'ideal_temp' => {
          sms: params[:ideal_temp][:sms].values.include?('true'),
          email: params[:ideal_temp][:email].values.include?('true')
        },
        'extended_use' => {
          sms: params[:extended_use][:sms].values.include?('true'),
          email: params[:extended_use][:email].values.include?('true')
        }
      },
      ideal_temperature: params[:ideal_temperature].to_i,
      phone: Phoner::Phone.parse(params[:phone]).format("%a%n"),
      email: params[:email]
    }
  end
end
