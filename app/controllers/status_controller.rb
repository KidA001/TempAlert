class StatusController < ApplicationController
  def index
    @current_record = Record.current || Record.new(temperature: 103, recorded_at: Time.now)
  end
end
