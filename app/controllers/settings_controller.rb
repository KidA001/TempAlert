class SettingsController < ApplicationController
  before_action :validate_session!

  def index
    @subscriber = current_subscriber
  end

  def update
    current_subscriber.update(update_params)
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
        'left_on' => {
          sms: params[:left_on][:sms].values.include?('true'),
          email: params[:left_on][:email].values.include?('true')
        }
      },
      ideal_temperature: params[:ideal_temperature].to_i,
      phone: params[:phone],
      email: params[:email]
    }
  end
end
