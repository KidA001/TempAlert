# frozen_string_literal: true

class StatusController < ApplicationController
  def index
    @current_time = Time.now.in_time_zone("Pacific Time (US & Canada)")
    @daytime = StatusHelper.daytime?
    @current_record = Record.current
  end
end
